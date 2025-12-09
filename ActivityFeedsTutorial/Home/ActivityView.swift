//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import SwiftUI

struct ActivityView: View {
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                AvatarView(url: nil)
                VStack(alignment: .leading) {
                    HStack {
                        Text("Name")
                            .font(.subheadline)
                            .foregroundStyle(.primary)
                        Text(Date().formatted(date: .long, time: .shortened))
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    Text("Text")
                }
                Spacer()
            }
            HStack(spacing: 16) {
                Button("0", systemImage: "bubble") {}
                Button("0", systemImage: "heart") {}
            }
            .foregroundStyle(.secondary)
            .padding(4)
        }
    }
}
