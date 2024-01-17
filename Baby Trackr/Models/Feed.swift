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

@Model
final class Feed {
    var child: Child? = nil
    var createdAt: Date = Date()
    var type: FeedType {
        return FeedType(rawValue: self.typeValue)!
    }
    var typeValue: String = FeedType.bottle.rawValue
    
    init(type: FeedType) {
        self.typeValue = type.rawValue
    }
}
