//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import StreamFeeds
import SwiftUI

struct CommentListView: View {
    @Environment(\.feedsClient) var client
    let activity: Activity
    let commentList: ActivityCommentList
    @ObservedObject var state: ActivityCommentListState
    @State private var commentText = ""
    
    init(activity: Activity, commentList: ActivityCommentList) {
        self.activity = activity
        self.commentList = commentList
        _state = ObservedObject(wrappedValue: commentList.state)
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                if !state.comments.isEmpty {
                    ScrollView {
                        LazyVStack {
                            ForEach(state.comments) { comment in
                                CommentView(
                                    author: comment.user.name ?? comment.user.id,
                                    createdAt: comment.createdAt,
                                    text: comment.text ?? ""
                                )
                            }
                            if state.canLoadMore {
                                Button("Load More") {
                                    Task {
                                        do {
                                            try await commentList.queryMoreComments()
                                        } catch {
                                            log.error("Failed to load more comments", error: error)
                                        }
                                    }
                                }
                                .buttonStyle(.borderedProminent)
                            }
                        }
                    }
                } else {
                    ContentUnavailableView("There are no comments for this activity", systemImage: "bubble")
                }
                Divider()
                HStack {
                    TextField("Write a comment…", text: $commentText)
                    Button(
                        action: {
                            Task {
                                do {
                                    try await activity.addComment(
                                        request: .init(
                                            comment: commentText.trimmingCharacters(in: .whitespacesAndNewlines)
                                        )
                                    )
                                    commentText = ""
                                } catch {
                                    log.error("Failed to add a comment", error: error)
                                }
                            }
                        },
                        label: {
                            Image(systemName: "paperplane")
                        }
                    )
                    .buttonStyle(.borderedProminent)
                    .disabled(commentText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
                .padding()
            }
            .navigationTitle("Comments")
            .task(id: commentList.query.objectId) {
                do {
                    try await commentList.get()
                } catch {
                    log.error("Failed to fetch comments", error: error)
                }
            }
        }
    }
}
