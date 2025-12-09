//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import SwiftUI

struct ThumbnailImage: View {
    let url: URL?
    let size: CGSize
    
    @State private var thumbnail: UIImage?
    
    var body: some View {
        Group {
            if let thumbnail {
                Image(uiImage: thumbnail)
                    .resizable()
                    .scaledToFill()
                    
            } else {
                Color(UIColor.secondarySystemBackground)
                    .overlay(
                        Image(systemName: "photo")
                    )
            }
        }
        .frame(width: size.width, height: size.height)
        .clipped()
        .cornerRadius(8)
        .task(id: url?.absoluteString ?? "") {
            await loadThumbnail()
        }
    }
    
    private func loadThumbnail() async {
        guard let url else {
            thumbnail = nil
            return
        }
        thumbnail = await withTaskGroup(of: UIImage?.self) { group in
            group.addTask {
                let imageSource: CGImageSource? = await {
                    if url.isFileURL {
                        return CGImageSourceCreateWithURL(url as CFURL, nil)
                    } else {
                        guard let (data, _) = try? await URLSession.shared.data(from: url) else { return nil }
                        return CGImageSourceCreateWithData(data as CFData, nil)
                    }
                }()
                guard let imageSource else { return nil }
                let maxDimension = max(size.width, size.height) * UITraitCollection.current.displayScale
                let options: [CFString: Any] = [
                    kCGImageSourceCreateThumbnailFromImageAlways: true,
                    kCGImageSourceCreateThumbnailWithTransform: true,
                    kCGImageSourceThumbnailMaxPixelSize: maxDimension
                ]
                guard let cgImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, options as CFDictionary) else {
                    return nil
                }
                let image = UIImage(cgImage: cgImage)
                return await image.byPreparingForDisplay() ?? image
            }
            return await group.next() ?? nil
        }
    }
}
