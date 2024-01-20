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
    
    var humanReadableDuration: String {
        let hours = self.duration / 3600
        let minutes = (self.duration % 3600) / 60
        let seconds = (self.duration % 3600) % 60
        
        if hours > 0 {
            return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        }
        
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
