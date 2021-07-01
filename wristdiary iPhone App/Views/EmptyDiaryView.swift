//
//  EmptyDiaryView.swift
//  wristdiary iPhone App
//
//  Created by Benjamin Lorenz on 23.06.21.
//

import SwiftUI

struct EmptyDiaryView: View {
    var body: some View {
        VStack(alignment: .center) {
            Spacer()
            Text("Empty diary")
                .multilineTextAlignment(.center)
            Spacer()
        }
    }
}
