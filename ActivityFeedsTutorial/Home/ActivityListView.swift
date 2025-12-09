//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import SwiftUI

struct ActivityListView: View {
    let hasContent = false
    
    var body: some View {
        if hasContent {
            ScrollView {
                LazyVStack {
                    ActivityView()
                }
            }
        } else {
            ContentUnavailableView("There are no activities for this feed", systemImage: "newspaper")
        }
    }
}
