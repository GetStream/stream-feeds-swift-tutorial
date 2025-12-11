//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import StreamFeeds
import SwiftUI

struct ExploreView: View {
    let feed: Feed
    
    var body: some View {
        NavigationStack {
            ActivityListView(feed: feed)
                .task(id: feed.feed) {
                    do {
                        try await feed.getOrCreate()
                    } catch {
                        log.error("Failed to load explore page", error: error)
                    }
                }
                .navigationTitle("For You")
        }
    }
}
