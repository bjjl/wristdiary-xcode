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
    @StateObject var realmController = RealmDataController()
    
    var body: some View {
        ListEntriesView()
    }
}
