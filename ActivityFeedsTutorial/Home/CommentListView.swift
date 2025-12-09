//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import SwiftUI

struct CommentListView: View {
    @State private var commentText = ""
    let hasContent = true
    
    var body: some View {
        NavigationStack {
            VStack {
                if hasContent {
                    ScrollView {
                        LazyVStack {
                            ForEach(1..<5) { index in
                                CommentView(author: "Author \(index)", createdAt: .now, text: "Text")
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
        }
    }
}
