//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import StreamFeeds
import SwiftUI

struct ActivityView: View {
    @Environment(\.feedsClient) var client
    let activityData: ActivityData
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                AvatarView(url: activityData.user.imageURL)
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text(activityData.user.name ?? activityData.user.id)
                            .font(.subheadline)
                            .foregroundStyle(.primary)
                        Text(activityData.createdAt.formatted(date: .abbreviated, time: .shortened))
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    Text(activityData.text ?? "")
                }
                Spacer()
            }
            HStack(spacing: 16) {
                Button("\(activityData.commentCount)", systemImage: "bubble") {}
                Button("\(activityData.reactionCount)", systemImage: "heart") {}
                if let currentFeed = activityData.currentFeed, currentFeed.feed != FeedId(group: "user", id: client.user.id) {
                    ToggleFollowButton(feedData: currentFeed)
                }
            }
            .foregroundStyle(.secondary)
            .padding(4)
        }
        .padding(.horizontal, 8)
    }
}
