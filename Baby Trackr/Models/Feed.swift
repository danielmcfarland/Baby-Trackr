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
        return BottleType(rawValue: self.typeValue)!
    }
    var bottleTypeValue: String = BottleType.unknown.rawValue
    
    var breastSide: BreastSide {
        return BreastSide(rawValue: self.typeValue)!
    }
    var breastSideValue: String = BreastSide.unknown.rawValue
    
    var bottleSize: BottleSize {
        return BottleSize(rawValue: self.typeValue)!
    }
    var bottleSizeValue: String = BottleSize.unknown.rawValue
    
    init(type: FeedType) {
        self.typeValue = type.rawValue
    }
}
