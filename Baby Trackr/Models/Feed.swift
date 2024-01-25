//
//  Feed.swift
//  Baby Trackr
//
//  Created by Daniel McFarland on 11/01/2024.
//

import Foundation
import SwiftData

enum FeedType: String, CaseIterable, Codable, Identifiable {
    case bottle = "Bottle"
    case breast = "Breast"
    
    var id: Self { self }
}

enum BottleType: String, CaseIterable, Codable, Identifiable {
    case unknown = "Unknown"
    case formula = "Formula"
    case express = "Express"
    
    var id: Self { self }
}

enum BreastSide: String, CaseIterable, Codable, Identifiable {
    case unknown = "Unknown"
    case left = "Left"
    case right = "Right"
    case both = "Both"
    
    var id: Self { self }
}

enum BottleSize: String, CaseIterable, Codable, Identifiable {
    case ml150 = "150 ml"
    case ml250 = "250 ml"
    case floz5 = "5 fl oz"
    case floz9 = "9 fl oz"
    
    var id: Self { self }
    
    var value: Int {
        switch self {
        case .floz5:
            return 5
        case .floz9:
            return 9
        case .ml150:
            return 150
        case .ml250:
            return 250
        }
    }
    
    var units: BottleUnit {
        switch self {
        case .floz5, .floz9:
            return BottleUnit.oz
        case .ml150, .ml250:
            return BottleUnit.ml
        }
    }
}

enum BottleUnit: String, CaseIterable, Codable, Identifiable {
    case ml = "ml"
    case oz = "fl oz"
    
    var id: Self { self }
}

@Model
final class Feed {
    var child: Child? = nil
    var createdAt: Date = Date()
    var timerStartedAt: Date? = nil
    var trackrRunning: Bool = false
    var duration: Int = 0
    var value: Int = 0

    var type: FeedType {
        return FeedType(rawValue: self.typeValue)!
    }
    var typeValue: String = FeedType.bottle.rawValue
    
    var bottleType: BottleType {
        return BottleType(rawValue: self.bottleTypeValue)!
    }
    var bottleTypeValue: String = BottleType.unknown.rawValue
    
    var breastSide: BreastSide {
        return BreastSide(rawValue: self.breastSideValue)!
    }
    var breastSideValue: String = BreastSide.unknown.rawValue
    
    var bottleUnit: BottleUnit {
        return BottleUnit(rawValue: self.bottleUnitValue)!
    }
    var bottleUnitValue: String = BottleUnit.ml.rawValue
    
    init(type: FeedType) {
        self.typeValue = type.rawValue
    }
    
    var humanReadableDuration: String {
        let hours = self.duration / 3600
        let minutes = (self.duration % 3600) / 60
        let seconds = (self.duration % 3600) % 60
        
        if hours > 0 {
            return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        }
        
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
