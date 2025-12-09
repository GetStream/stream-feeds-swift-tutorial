//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import SwiftUI

struct ExploreView: View {
    var body: some View {
        NavigationStack {
            ContentUnavailableView("There are no activities for this feed", systemImage: "newspaper")
                .navigationTitle("For You")
        }
    }
}
