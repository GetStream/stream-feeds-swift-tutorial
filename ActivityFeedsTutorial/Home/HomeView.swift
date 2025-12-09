//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationStack {
            VStack {
                ActivityComposerView()
                Divider()
                ActivityListView()
            }
            .navigationTitle("Stream Activity Feeds")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
