//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation

struct UserCredentials {
    let apiKey: String
    let id: String
    let name: String?
    let token: String
}

extension UserCredentials {
    static var current: UserCredentials {
        UserCredentials(
            apiKey: "REPLACE_WITH_API_KEY",
            id: "REPLACE_WITH_USER_ID",
            name: "REPLACE_WITH_USER_NAME",
            token: "REPLACE_WITH_USER_TOKEN"
        )
    }
}
