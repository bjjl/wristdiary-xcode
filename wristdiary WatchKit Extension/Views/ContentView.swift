//
//  ContentView.swift
//  wristdiary WatchKit Extension
//
//  Created by Benjamin Lorenz on 28.05.21.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var data = DataController.shared
    @State var entries: [EntryData] = []
    private let ioManager = IOManager()

    var body: some View {
        TabView {
            ListEntriesView()
                .navigationTitle("My Diary")
                .onAppear {
                    ioManager.receiveEntries(user_id: DataController.shared.user_id)
                }

            DateSelectionView()
                .navigationTitle("Select Date")

/*
            NavigationView {
                QRCodeView(stringData: DataController.shared.user_id +
                            " " +
                            DataController.shared.key.withUnsafeBytes { Data(Array($0)).base64EncodedString() })
            }
            .navigationTitle("My Identity")
            
            NavigationView {
                LocationInfoView()
            }
            .navigationTitle("My Location")
*/
        }
    }
}
