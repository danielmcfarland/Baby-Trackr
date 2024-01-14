//
//  CurrentSleepView.swift
//  Baby Trackr
//
//  Created by Daniel McFarland on 14/01/2024.
//

import SwiftUI
import Combine

struct CurrentSleepView: View {
    
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) var dismiss
    
    var child: Child
    @State var sleep: Sleep
    @State var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    func secondsToHoursMinutesSeconds(_ seconds: Int) -> String {
        let hours = seconds / 3600
        let minutes = (seconds % 3600) / 60
        let seconds = (seconds % 3600) % 60
        
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
    var body: some View {
        VStack {
            Text("\(secondsToHoursMinutesSeconds(sleep.duration))")
                .font(.system(size: 75))
                .fontWeight(.light)
            
            HStack {
                Button(action: {
                    sleep.startTime = Date()
                    sleep.isActive = true
                    saveSleep()
                }) {
                    IconView(size: .large, icon: "play.fill")
                        .opacity(sleep.isActive ? 0.8 : 1)
                }
                .disabled(sleep.isActive)
                
                Button(action: {
                    sleep.isActive = false
                    sleep.endTime = Date()
                    saveSleep()
                }) {
                    IconView(size: .large, icon: "stop.fill")
                        .opacity(sleep.isActive ? 1 : 0.8)
                }
                .disabled(!sleep.isActive)
            }
        }
        .onReceive(timer) { firedDate in
            if !sleep.isActive {
                return
            }
            guard let startTime = sleep.startTime else {
                return
            }
            
            sleep.duration = Int(firedDate.timeIntervalSince(startTime))
            
            saveSleep()
            
        }
    }
    
    func saveSleep() -> Void {
        modelContext.insert(sleep)
        child.sleeps?.append(sleep)
    }
}

#Preview {
    CurrentSleepView(child: Child(name: "Name", dob: Date(), gender: ""), sleep: Sleep())
}
