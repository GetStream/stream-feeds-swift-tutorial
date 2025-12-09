//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import SwiftUI

struct CommentView: View {
    let author: String
    let createdAt: Date
    let text: String
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(author)
                        .font(.subheadline)
                        .foregroundStyle(.primary)
                    Text(createdAt.formatted(date: .abbreviated, time: .shortened))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .lineLimit(1)
                Text(text)
            }
            Spacer()
        }
        .padding()
    }
}
