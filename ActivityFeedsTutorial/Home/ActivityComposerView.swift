//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import StreamFeeds
import SwiftUI

struct ActivityComposerView: View {
    @State private var text = ""
    let feed: Feed
    
    var body: some View {
        VStack(alignment: .leading) {
            TextField("What is happening?", text: $text)
            HStack {
                Spacer()
                Button(
                    action: {},
                    label: { Image(systemName: "photo") }
                )
                .buttonStyle(.bordered)
                Button(
                    action: {
                        Task {
                            do {
                                try await feed.addActivity(
                                    request: .init(
                                        text: text.trimmingCharacters(in: .whitespacesAndNewlines),
                                        type: "post"
                                    )
                                )
                                text = ""
                            } catch {
                                log.error("Failed to add activity", error: error)
                            }
                        }
                    },
                    label: { Image(systemName: "paperplane") }
                )
                .buttonStyle(.borderedProminent)
                .disabled(text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
        }
        .padding()
    }
}
