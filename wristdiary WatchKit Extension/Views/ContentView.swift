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
            NavigationView {
                ListEntriesView()
            }
            .onAppear {
                ioManager.receiveEntries(user_id: DataController.shared.user_id)
            }
            .navigationTitle("My Diary")
            
            NavigationView {
                DateSelectionView()
            }
            .navigationTitle("Select Date")
            
            NavigationView {
                QRCodeView(stringData: DataController.shared.user_id +
                            " " +
                            DataController.shared.key.withUnsafeBytes { Data(Array($0)).base64EncodedString() })
            }
            .navigationTitle("My Identity")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
