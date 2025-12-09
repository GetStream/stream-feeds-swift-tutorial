//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import SwiftUI

struct ToggleFollowButton: View {
    @State private var isFollowing: Bool
    
    var body: some View {
        Button(isFollowing ? "Unfollow" : "Follow") {
        }
        .font(.callout)
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .foregroundStyle(isFollowing ? Color.red : Color.green)
        .background(isFollowing ? Color.red.brightness(0.6) : Color.green.brightness(0.6))
        .clipShape(RoundedRectangle(cornerRadius: 4))
    }
}
