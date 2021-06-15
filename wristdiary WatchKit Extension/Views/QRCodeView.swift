//
//  QRCodeView.swift
//  wristdiary WatchKit Extension
//
//  Created by Benjamin Lorenz on 30.05.21.
//

import SwiftUI
import EFQRCode

struct QRCodeView: View {
    @ObservedObject var data = DataController.shared
    
    var stringData: String
    
    init(stringData: String) {
        self.stringData = stringData
    }

    var body: some View {
        //ScrollView {
        //    VStack {
                //Text("\nScan for Backup\n")
                //    .multilineTextAlignment(.center)
                //    .font(.footnote)
                Image(uiImage: UIImage(cgImage: qrImage()))
                    .resizable()
                    .scaledToFit()
                    //.padding(2)
        //    }
        //}
    }
    
    func qrImage() -> CGImage {
        let image = EFQRCode.generate(
            for: self.stringData)
        return image!
    }
}
