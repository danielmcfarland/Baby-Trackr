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
            
            for i in 1...1 {
                let child = Child(name: "Name \(i)", dob: Date.now, gender: "")
                container.mainContext.insert(child)
                
                let feed = Feed(type: .bottle)
//                feed.bottleSizeValue = BottleSize.one.rawValue
                feed.bottleTypeValue = BottleType.formula.rawValue
                feed.child = child
                container.mainContext.insert(feed)
            }
            
            return container
        } catch {
            fatalError("Failed to create model container for previewing: \(error)")
        }
    }()
}
