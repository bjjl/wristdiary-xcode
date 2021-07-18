//
//  LocationInfoView.swift
//  wristdiary WatchKit Extension
//
//  Created by Benjamin Lorenz on 18.07.21.
//

import SwiftUI

struct LocationInfoView: View {
    @ObservedObject var lm = LocationManager()

    var placemark: String { return("\(lm.placemark?.name ?? "Unknown")") }

    var body: some View {
        VStack {
            Text("Placemark\n\n\(self.placemark)")
                .multilineTextAlignment(.center)
        }
    }
}
