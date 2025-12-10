//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import StreamFeeds
import SwiftUI

struct HomeView: View {
    @Environment(\.feedsClient) var client
    let timeline: Feed
    
    var body: some View {
        NavigationStack {
            VStack {
                ActivityComposerView()
                Divider()
                ActivityListView(feed: timeline)
            }
            .navigationTitle("Stream Activity Feeds")
            .navigationBarTitleDisplayMode(.inline)
            .task(id: timeline.feed) {
                do {
                    try await timeline.getOrCreate()
                    
                    // You typically create these relationships on your server-side, we do this here for simplicity
                    let connectedUserId = client.user.id
                    let ownFeed = client.feed(
                        group: "user",
                        id: connectedUserId
                    )
                    try await ownFeed.getOrCreate()
                    
                    let alreadyFollows = ownFeed.state.feedData?.ownFollows?
                        .contains(where: { $0.sourceFeed.feed == timeline.feed }) ?? false
                    if !alreadyFollows {
                        try await timeline.follow(ownFeed.feed)
                    }
                } catch {
                    log.error("Failed to fetch own feed data", error: error)
                }
            }
        }
    }
}
