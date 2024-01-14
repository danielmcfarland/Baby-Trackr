//
//  Sleep.swift
//  Baby Trackr
//
//  Created by Daniel McFarland on 11/01/2024.
//

import Foundation
import SwiftData

@Model
final class Sleep {
    var child: Child? = nil
    var startTime: Date?
    var duration: Int = 0
    var endTime: Date? = nil
    var isActive: Bool = false
    
    init() {
        
    }
}
