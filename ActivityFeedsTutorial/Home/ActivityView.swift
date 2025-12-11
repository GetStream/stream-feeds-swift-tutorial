//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import StreamFeeds
import SwiftUI

struct ActivityView: View {
    @Environment(\.feedsClient) var client
    let activityData: ActivityData
    let feedId: FeedId
    
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
                Button(
                    "\(activityData.reactionGroups["heart"]?.count ?? 0)",
                    systemImage: activityData.ownReactions.isEmpty ? "heart" : "heart.fill"
                ) {
                    Task {
                        do {
                            let activity = client.activity(for: activityData.id, in: feedId)
                            if activityData.ownReactions.isEmpty {
                                try await activity.addReaction(request: .init(type: "heart"))
                            } else {
                                try await activity.deleteReaction(type: "heart")
                            }
                        } catch {
                            log.error("Failed to toggle reaction", error: error)
                        }
                    }
                }
                .foregroundStyle(activityData.ownReactions.isEmpty ? .secondary : Color.red)
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
