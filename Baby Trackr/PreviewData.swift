//
//  PreviewData.swift
//  Baby Trackr
//
//  Created by Daniel McFarland on 20/01/2024.
//

import Foundation
import SwiftData

@MainActor
class PreviewData {
    static let container: ModelContainer = {
        do {
            let config = ModelConfiguration(isStoredInMemoryOnly: true)
            let container = try ModelContainer(for: Child.self, configurations: config)
            
            let child = Child(name: "Child Name", dob: Date.now, gender: "")
            container.mainContext.insert(child)
            
            for j in 1...5 {
                let sleep = Sleep()
                sleep.createdAt = Calendar.current.date(byAdding: .day, value: -j, to: Date())!
                sleep.duration = j * 3600
                sleep.child = child
                container.mainContext.insert(sleep)
            }
            
            for j in 1...5 {
                let sleep = Sleep()
                sleep.createdAt = Calendar.current.date(byAdding: .hour, value: -j, to: Date())!
                sleep.duration = j * 3600
                sleep.child = child
                container.mainContext.insert(sleep)
            }
            
            for k in 1...5 {
                let sleep = Sleep()
                sleep.createdAt = Calendar.current.date(byAdding: .day, value: -30-k, to: Date())!
                sleep.duration = k * 3600
                sleep.child = child
                container.mainContext.insert(sleep)
            }
            
            let feed = Feed(type: .bottle)
            feed.bottleTypeValue = BottleType.formula.rawValue
            feed.child = child
            container.mainContext.insert(feed)
            
            return container
        } catch {
            fatalError("Failed to create model container for previewing: \(error)")
        }
    }()
}
