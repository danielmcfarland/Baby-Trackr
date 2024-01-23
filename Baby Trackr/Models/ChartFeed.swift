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
    
    init(duration: Int, breastSide: BreastSide) {
        self.duration = duration
        self.breastSide = breastSide
    }
    
    static func == (lhs: ChartFeed, rhs: ChartFeed) -> Bool {
        rhs.duration == lhs.duration &&
        rhs.breastSide.rawValue == lhs.breastSide.rawValue
    }
}
