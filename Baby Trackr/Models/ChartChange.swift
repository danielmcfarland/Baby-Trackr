//
//  ChartChange.swift
//  Baby Trackr
//
//  Created by Daniel McFarland on 24/01/2024.
//

import Foundation

class ChartChange: Equatable {
    var value: Int
    var type: ChangeType
    
    init(value: Int, type: ChangeType) {
        self.value = value
        self.type = type
    }
    
    static func == (lhs: ChartChange, rhs: ChartChange) -> Bool {
        rhs.value == lhs.value &&
        rhs.type.rawValue == lhs.type.rawValue
    }
}
