//
//  ChartChange.swift
//  Baby Trackr
//
//  Created by Daniel McFarland on 24/01/2024.
//

import Foundation

class ChartChange: Equatable {
    var date: Date
    var value: Int
    var type: ChangeType
    
    init(date: Date, value: Int, type: ChangeType) {
        self.date = date
        self.value = value
        self.type = type
    }
    
    static func == (lhs: ChartChange, rhs: ChartChange) -> Bool {
        rhs.value == lhs.value &&
        rhs.type.rawValue == lhs.type.rawValue &&
        rhs.date == lhs.date
    }
}
