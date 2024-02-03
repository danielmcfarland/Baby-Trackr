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
                
                let dirtyChange = Change(type: .dirty)
                dirtyChange.createdAt = Calendar.current.date(byAdding: .day, value: -j, to: Date())!
                dirtyChange.child = child
                container.mainContext.insert(dirtyChange)
                
                let wetChange = Change(type: .wet)
                wetChange.createdAt = Calendar.current.date(byAdding: .day, value: -j, to: Date())!
                wetChange.child = child
                container.mainContext.insert(wetChange)
                
                let dryChange = Change(type: .dry)
                dryChange.createdAt = Calendar.current.date(byAdding: .day, value: -j, to: Date())!
                dryChange.child = child
                container.mainContext.insert(dryChange)
                
                let feedLeft = Feed(type: .breast)
                feedLeft.createdAt = Calendar.current.date(byAdding: .day, value: -j, to: Date())!
                feedLeft.duration = j * 3600
                feedLeft.breastSideValue = BreastSide.left.rawValue
                feedLeft.child = child
                container.mainContext.insert(feedLeft)
                
                let feedRight = Feed(type: .breast)
                feedRight.createdAt = Calendar.current.date(byAdding: .day, value: -j, to: Date())!
                feedRight.duration = j * 1800
                feedRight.breastSideValue = BreastSide.right.rawValue
                feedRight.child = child
                container.mainContext.insert(feedRight)
                
                let feedBoth = Feed(type: .breast)
                feedBoth.createdAt = Calendar.current.date(byAdding: .day, value: -j, to: Date())!
                feedBoth.duration = j * 900
                feedBoth.breastSideValue = BreastSide.both.rawValue
                feedBoth.child = child
                container.mainContext.insert(feedBoth)
                
                let feedUnknown = Feed(type: .breast)
                feedUnknown.createdAt = Calendar.current.date(byAdding: .day, value: -j, to: Date())!
                feedUnknown.duration = j * 450
                feedUnknown.breastSideValue = BreastSide.unknown.rawValue
                feedUnknown.child = child
                container.mainContext.insert(feedUnknown)
                
                let formula = Feed(type: .bottle)
                formula.createdAt = Calendar.current.date(byAdding: .day, value: -j, to: Date())!
                formula.value = j * 100
                formula.bottleTypeValue = BottleType.formula.rawValue
                formula.child = child
                container.mainContext.insert(formula)
                
                let express = Feed(type: .bottle)
                express.createdAt = Calendar.current.date(byAdding: .day, value: -j, to: Date())!
                express.value = j * 200
                express.bottleTypeValue = BottleType.express.rawValue
                express.child = child
                container.mainContext.insert(express)
                
                let unknown = Feed(type: .bottle)
                unknown.createdAt = Calendar.current.date(byAdding: .day, value: -j, to: Date())!
                unknown.value = j * 50
                unknown.bottleTypeValue = BottleType.unknown.rawValue
                unknown.child = child
                container.mainContext.insert(unknown)
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
