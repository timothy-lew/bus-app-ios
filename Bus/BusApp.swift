//
//  BusApp.swift
//  Bus
//
//  Created by Timothy on 25/11/23.
//

import SwiftData
import SwiftUI

@main
struct BusApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: BookmarkBus.self)
    }
}
