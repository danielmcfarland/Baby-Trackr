//
//  Item.swift
//  Baby Trackr
//
//  Created by Daniel McFarland on 10/01/2024.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date = Date()
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
