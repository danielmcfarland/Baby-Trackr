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
    @EnvironmentObject var trackr: Trackr
    
    var child: Child
    @State var sleep: Sleep
    
    var body: some View {
        VStack {
            Text("\(sleep.humanReadableDuration)")
                .font(.system(size: 75))
                .fontWeight(.light)
            
            HStack {
                Button(action: {
                    if sleep.startTime == nil {
                        sleep.startTime = Date()
                        sleep.isActive = true
                        saveSleep()
                    }
                }) {
                    IconView(size: .large, icon: "play.fill")
                        .opacity(sleep.isActive ? 0.8 : 1)
                }
                .disabled(sleep.isActive)
                
                Button(action: {
                    sleep.isActive = false
                    sleep.endTime = Date()
                    updateSleep()
                }) {
                    IconView(size: .large, icon: "stop.fill")
                        .opacity(sleep.isActive ? 1 : 0.8)
                }
                .disabled(!sleep.isActive)
            }
        }
        .navigationTitle("Sleep")
        .navigationBarTitleDisplayMode(.large)
        .onReceive(trackr.timer) { firedDate in
            if !sleep.isActive {
                return
            }
            guard let startTime = sleep.startTime else {
                return
            }
            
            sleep.duration = Int(firedDate.timeIntervalSince(startTime))
            updateSleep()
            
        }
    }
    
    func saveSleep() -> Void {
        modelContext.insert(sleep)
        child.sleeps?.append(sleep)
    }
    
    func updateSleep() -> Void {
        if modelContext.hasChanges {
            do {
                try modelContext.save()
            } catch {
                print(error)
            }
        }
    }
}

#Preview {
    CurrentSleepView(child: Child(name: "Name", dob: Date(), gender: ""), sleep: Sleep())
}
