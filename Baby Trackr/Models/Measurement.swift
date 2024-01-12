//
//  Measurement.swift
//  Baby Trackr
//
//  Created by Daniel McFarland on 11/01/2024.
//

import Foundation
import SwiftData

enum MeasurementType: String, Codable {
    case weight = "Weight"
    case height = "Height"
}

@Model
final class Measurement {
    var child: Child? = nil
    
    var type: MeasurementType = MeasurementType.weight
    var value: Int = 0
    
    init(type: MeasurementType, value: Int) {
        self.type = type
        self.value = value
    }
}
