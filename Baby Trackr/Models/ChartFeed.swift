//
//  ChartFeed.swift
//  Baby Trackr
//
//  Created by Daniel McFarland on 23/01/2024.
//

import Foundation

class ChartFeed: Equatable {
    var date: Date
    var value: Double
    var breastSide: BreastSide
    var bottleType: BottleType
    
    init(date: Date, duration: Double, breastSide: BreastSide, bottleType: BottleType) {
        self.date = date
        self.value = duration
        self.breastSide = breastSide
        self.bottleType = bottleType
    }
    
    static func == (lhs: ChartFeed, rhs: ChartFeed) -> Bool {
        rhs.value == lhs.value &&
        rhs.breastSide.rawValue == lhs.breastSide.rawValue &&
        rhs.bottleType.rawValue == lhs.bottleType.rawValue
    }
}
