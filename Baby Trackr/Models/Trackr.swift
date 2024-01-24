//
//  Trackr.swift
//  Baby Trackr
//
//  Created by Daniel McFarland on 16/01/2024.
//

import Foundation
import Combine

class Trackr: ObservableObject {
    @Published var timer = Timer.publish(every: 0.001, on: .main, in: .common).autoconnect()
    var initialised: Bool = false
    var running: Bool = true
    var startedAt: Date?
    var duration: Int = 0
    var durationTotal: Int = 0
    
    func pauseTimer() -> Void {
        self.running = false
        self.durationTotal = durationTotal + duration
        self.duration = 0
        self.startedAt = nil
    }
    
    func startTimer(duration: Int?) -> Void {
        if !self.initialised {
            self.startedAt = Date.now
            if let duration = duration {
                self.durationTotal = duration
            }
        }
        
        if (self.startedAt == nil) {
            self.startedAt = Date.now
        }
        self.running = true
    }
    
    func initTimer(startedAt: Date, duration: Int) -> Void {
        if self.initialised {
            return
        }
        
        self.initialised = true
        self.startedAt = startedAt
        self.durationTotal = duration
    }
    
    func deinitTimer() -> Void {
        self.initialised = false
        self.duration = 0
        self.durationTotal = 0
        self.running = false
    }
}
