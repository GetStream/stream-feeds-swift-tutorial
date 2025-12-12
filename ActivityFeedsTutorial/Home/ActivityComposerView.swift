//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import PhotosUI
import StreamFeeds
import SwiftUI

struct ActivityComposerView: View {
    @State private var text = ""
    let feed: Feed
    @State private var selectedPhotos: [PhotosPickerItem] = []
    @State private var photoURLs = [URL]()
    
    var body: some View {
        VStack(alignment: .leading) {
            TextField("What is happening?", text: $text)
            if !photoURLs.isEmpty {
                HStack {
                    ForEach(photoURLs, id: \.absoluteString) { url in
                        ThumbnailImage(url: url, size: CGSize(width: 50, height: 50))
                    }
                }
            }
            HStack {
                Spacer()
                Button(
                    action: {},
                    label: { Image(systemName: "photo") }
                )
                .buttonStyle(.bordered)
                .overlay {
                    PhotosPicker(
                        selection: $selectedPhotos,
                        matching: .images
                    ) {
                        Color.clear
                    }
                }
                Button(
                    action: {
                        Task {
                            do {
                                let attachments = try photoURLs
                                    .compactMap { try AnyAttachmentPayload(localFileURL: $0, attachmentType: .image) }
                                try await feed.addActivity(
                                    request: .init(
                                        attachmentUploads: attachments,
                                        text: text.trimmingCharacters(in: .whitespacesAndNewlines),
                                        type: "post"
                                    )
                                )
                                photoURLs = []
                                text = ""
                            } catch {
                                log.error("Failed to add activity", error: error)
                            }
                        }
                    },
                    label: { Image(systemName: "paperplane") }
                )
                .buttonStyle(.borderedProminent)
                .disabled(text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && photoURLs.isEmpty)
            }
        }
        .padding()
        .task(id: selectedPhotos, {
            do {
                photoURLs = try await withThrowingTaskGroup { group in
                    for (index, item) in selectedPhotos.enumerated() {
                        group.addTask {
                            let localURL = URL.temporaryDirectory.appending(path: "\(index)-\(item.itemIdentifier ?? UUID().uuidString)")
                            guard let photoData = try await item.loadTransferable(type: Data.self) else { throw ClientError.InvalidURL() }
                            try photoData.write(to: localURL)
                            return localURL
                        }
                    }
                    return try await group.reduce(into: []) { $0.append($1) }
                }
            } catch {
                log.error("Failed to prepare photos", error: error)
            }
        })
    }
}
