//
//  Baby_TrackrApp.swift
//  Baby Trackr
//
//  Created by Daniel McFarland on 10/01/2024.
//

import SwiftUI
import SwiftData

@main
struct Baby_TrackrApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Change.self,
            Child.self,
            Feed.self,
            Item.self,
            Measurement.self,
            Sleep.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
        .environmentObject(Trackr())
    }
}
