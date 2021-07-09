//
//  ContentView.swift
//  wristdiary iPhone App
//
//  Created by Benjamin Lorenz on 21.06.21.
//

import SwiftUI
import RealmSwift
import Realm

struct ContentView: View {    
    var body: some View {
        TabView {
            ListEntriesView()
                .tabItem {
                    Label("Timeline", systemImage: "note.text")
                }
            DateSelectionView()
                .tabItem {
                    Label("Selected Day", systemImage: "timeline.selection")
                }
        }
    }
}
