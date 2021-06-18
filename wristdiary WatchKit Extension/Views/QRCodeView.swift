//
//  QRCodeView.swift
//  wristdiary WatchKit Extension
//
//  Created by Benjamin Lorenz on 30.05.21.
//

import SwiftUI
import EFQRCode

struct QRCodeView: View {
    @State var showingIdentityEnterView = false
    @ObservedObject var data = DataController.shared
    
    var stringData = ""
    
    var body: some View {
        VStack {
            Image(uiImage: UIImage(cgImage: qrImage()))
                .resizable()
                .scaledToFit()
                .padding(.vertical, 5)
            Text("Scan to Export")
                .multilineTextAlignment(.center)
        }
    }
    
    func qrImage() -> CGImage {
        let image = EFQRCode.generate(
            for: self.stringData)
        return image!
    }
}
