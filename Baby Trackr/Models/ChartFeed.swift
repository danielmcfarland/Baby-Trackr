//
//  ChartFeed.swift
//  Baby Trackr
//
//  Created by Daniel McFarland on 23/01/2024.
//

import Foundation

class ChartFeed: Equatable {
    var duration: Int
    var breastSide: BreastSide
    var bottleType: BottleType
    
    init(duration: Int, breastSide: BreastSide, bottleType: BottleType) {
        self.duration = duration
        self.breastSide = breastSide
        self.bottleType = bottleType
    }
    
    static func == (lhs: ChartFeed, rhs: ChartFeed) -> Bool {
        rhs.duration == lhs.duration &&
        rhs.breastSide.rawValue == lhs.breastSide.rawValue &&
        rhs.bottleType.rawValue == lhs.bottleType.rawValue
    }
}
