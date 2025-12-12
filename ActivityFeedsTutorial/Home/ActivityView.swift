//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import StreamFeeds
import SwiftUI

struct ActivityView: View {
    @Environment(\.feedsClient) var client
    let activityData: ActivityData
    let feedId: FeedId
    @State private var showsComments = false
    
    var imageURLs: [URL] {
        activityData.attachments.compactMap(\.imageUrl).compactMap { URL(string: $0) }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top) {
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
                    if let text = activityData.text, !text.isEmpty {
                        Text(text)
                    }
                    
                    ForEach(imageURLs, id: \.absoluteString) { url in
                        ThumbnailImage(
                            url: url,
                            size: CGSize(width: 200, height: 150)
                        )
                    }
                }
                Spacer()
            }
            HStack(spacing: 16) {
                Button("\(activityData.commentCount)", systemImage: "bubble") {
                    showsComments = true
                }
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
        .sheet(isPresented: $showsComments) {
            CommentListView(
                activity: client.activity(
                    for: activityData.id,
                    in: feedId
                ),
                commentList: client.activityCommentList(
                    for: .init(
                        objectId: activityData.id,
                        objectType: "activity"
                    )
                )
            )
            .presentationDetents([.fraction(0.75)])
            .presentationDragIndicator(.visible)
        }
    }
}
