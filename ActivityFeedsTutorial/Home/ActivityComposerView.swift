//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import SwiftUI

struct ActivityComposerView: View {
    @State private var text = ""
    
    var body: some View {
        VStack(alignment: .leading) {
            TextField("What is happening?", text: $text)
            HStack {
                Spacer()
                Button(
                    action: {},
                    label: { Image(systemName: "photo") }
                )
                .buttonStyle(.bordered)
                Button(
                    action: {},
                    label: { Image(systemName: "paperplane") }
                )
                .buttonStyle(.borderedProminent)
            }
        }
        .padding()
    }
}
