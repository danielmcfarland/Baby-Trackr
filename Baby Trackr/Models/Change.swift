//
//  Change.swift
//  Baby Trackr
//
//  Created by Daniel McFarland on 11/01/2024.
//

import Foundation
import SwiftData

enum ChangeType: String, CaseIterable, Codable, Identifiable {
    case dry = "Dry"
    case wet = "Wet"
    case dirty = "Dirty"
    
    var id: Self { self }
}

@Model
final class Change {
    var child: Child? = nil
    var createdAt: Date = Date()
    var type: ChangeType {
        return ChangeType(rawValue: self.typeValue)!
    }
    var typeValue: String = ChangeType.dry.rawValue
    
    init(type: ChangeType) {
        self.typeValue = type.rawValue
    }
}
