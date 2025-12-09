//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import SwiftUI

struct RootView: View {
    var body: some View {
        TabView {
            Tab("Home", systemImage: "house") {
                HomeView()
            }
            Tab("Explore", systemImage: "magnifyingglass") {
                ExploreView()
            }
        }
    }
}
