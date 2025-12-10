//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import StreamFeeds
import SwiftUI

@main
struct ActivityFeedsTutorialApp: App {
    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(\.feedsClient, FeedsClient.current)
        }
    }
}

extension FeedsClient {
    @MainActor static var current: FeedsClient = {
        LogConfig.level = .info
        let credentials = UserCredentials.current
        return FeedsClient(
            apiKey: APIKey(credentials.apiKey),
            user: User(
                id: credentials.id,
                name: credentials.name
            ),
            token: UserToken(rawValue: credentials.token)
        )
    }()
}

extension EnvironmentValues {
    @Entry var feedsClient: FeedsClient = FeedsClient.current
}
