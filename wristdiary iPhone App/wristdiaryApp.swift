//
//  wristdiaryApp.swift
//  wristdiary iPhone App
//
//  Created by Benjamin Lorenz on 21.06.21.
//

import SwiftUI

@main
struct wristdiaryApp: App {
    let dataController = DataController.shared // first thing: fetch identity
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
