//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import StreamFeeds
import SwiftUI

struct ActivityListView: View {
    let feed: Feed
    @ObservedObject var state: FeedState
    
    init(feed: Feed) {
        self.feed = feed
        _state = ObservedObject(wrappedValue: feed.state)
    }
    
    var body: some View {
        if !state.activities.isEmpty {
            ScrollView {
                LazyVStack {
                    ForEach(state.activities) { activityData in
                        ActivityView(activityData: activityData)
                    }
                    if state.canLoadMoreActivities {
                        Button("Load More") {
                            Task {
                                do {
                                    try await feed.queryMoreActivities()
                                } catch {
                                    log.error("Failed to load more activities", error: error)
                                }
                            }
                        }
                        .buttonStyle(.borderedProminent)
                    }
                }
            }
        } else {
            ContentUnavailableView("There are no activities for this feed", systemImage: "newspaper")
        }
    }
}
