//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import StreamFeeds
import SwiftUI

struct ToggleFollowButton: View {
    @Environment(\.feedsClient) var client
    let feedData: FeedData
    @State private var isFollowing: Bool
    
    init(feedData: FeedData) {
        self.feedData = feedData
        self.isFollowing = feedData.ownFollows?.count ?? 0 > 0
    }
    
    var body: some View {
        Button(isFollowing ? "Unfollow" : "Follow") {
            Task {
                do {
                    let ownTimeline = client.feed(group: "timeline", id: client.user.id)
                    if isFollowing {
                        try await ownTimeline.unfollow(feedData.feed)
                    } else {
                        try await ownTimeline.follow(feedData.feed)
                    }
                    isFollowing.toggle()
                } catch {
                    log.error("Failed to toggle following", error: error)
                }
            }
        }
        .font(.callout)
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .foregroundStyle(isFollowing ? Color.red : Color.green)
        .background(isFollowing ? Color.red.brightness(0.6) : Color.green.brightness(0.6))
        .clipShape(RoundedRectangle(cornerRadius: 4))
    }
}
