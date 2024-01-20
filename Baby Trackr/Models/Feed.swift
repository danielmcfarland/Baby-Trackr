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
    case unknown = "Unknown"
    case one = "150 ml / 5 fl oz"
    case two = "250 ml / 9 fl oz"
    
    var id: Self { self }
}

@Model
final class Feed {
    var child: Child? = nil
    var createdAt: Date = Date()
    var duration: Int = 0

    var type: FeedType {
        return FeedType(rawValue: self.typeValue)!
    }
    var typeValue: String = FeedType.breast.rawValue
    
    var bottleType: BottleType {
        return BottleType(rawValue: self.bottleTypeValue)!
    }
    var bottleTypeValue: String = BottleType.unknown.rawValue
    
    var breastSide: BreastSide {
        return BreastSide(rawValue: self.breastSideValue)!
    }
    var breastSideValue: String = BreastSide.unknown.rawValue
    
    var bottleSize: BottleSize {
        return BottleSize(rawValue: self.bottleSizeValue)!
    }
    var bottleSizeValue: String = BottleSize.unknown.rawValue
    
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
