//
//  wristdiaryApp.swift
//  wristdiary WatchKit Extension
//
//  Created by Benjamin Lorenz on 28.05.21.
//

import SwiftUI

@main
struct wristdiaryApp: App {
    @Environment(\.scenePhase) private var scenePhase
    @SceneBuilder var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }
        }
    }
}
