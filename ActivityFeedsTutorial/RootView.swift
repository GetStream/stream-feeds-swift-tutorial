//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import StreamFeeds
import SwiftUI

struct RootView: View {
    @Environment(\.feedsClient) var client
    @State private var isConnected = false
    
    var body: some View {
        VStack {
            if isConnected {
                TabView {
                    Tab("Home", systemImage: "house") {
                        HomeView(
                            timeline: client.feed(
                                group: "timeline",
                                id: client.user.id
                            )
                        )
                    }
                    Tab("Explore", systemImage: "magnifyingglass") {
                        ExploreView()
                    }
                }
            } else {
                ProgressView("Connecting to the Stream API")
            }
        }
        .task(id: client.user.id) {
            do {
                try await client.connect()
                log.info("✅ User \(client.user.id) connected successfully")
                isConnected = true
            } catch {
                log.error("Failed to connect", error: error)
            }
        }
    }
}
