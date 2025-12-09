//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import SwiftUI

struct AvatarView: View {
    let url: URL?
    
    var body: some View {
        AsyncImage(url: nil) { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fill)
        } placeholder: {
            Color(UIColor.secondarySystemBackground)
                .overlay {
                    Image(systemName: "person")
                }
        }
        .frame(width: 36, height: 36)
        .cornerRadius(18)
    }
}
