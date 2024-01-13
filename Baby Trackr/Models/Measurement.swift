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
    case temperature = "Temperature"
    
    func getSymbol() -> String {
        switch self {
        case .weight:
            return "g"
        case .height:
            return "cm"
        case .temperature:
            return "°C"
        }
    }
}

@Model
final class Measurement {
    var child: Child? = nil
    
    var type: MeasurementType {
        return MeasurementType(rawValue: self.typeValue)!
    }
    var typeValue: String = MeasurementType.weight.rawValue
    var value: Int = 0
    var createdAt: Date = Date()
    
    init(type: MeasurementType, value: Int, createdAt: Date) {
        self.value = value
        self.typeValue = type.rawValue
        self.createdAt = createdAt
    }
}
