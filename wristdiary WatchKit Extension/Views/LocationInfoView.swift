//
//  LocationInfoView.swift
//  wristdiary WatchKit Extension
//
//  Created by Benjamin Lorenz on 18.07.21.
//

import SwiftUI

struct LocationInfoView: View {
    var placemark: Text

    init() {
        if let locality = LocationManager.shared.placemark?.locality {
            placemark = Text(locality)
        } else {
            placemark = Text("Unknown")
        }
    }
    
    var body: some View {
        VStack {
            placemark
                .font(.system(size: 24))
                .multilineTextAlignment(.center)
        }
    }
}
