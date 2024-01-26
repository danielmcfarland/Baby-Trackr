//
//  SleepEntryView.swift
//  Baby Trackr
//
//  Created by Daniel McFarland on 24/01/2024.
//

import SwiftUI
import SwiftData

struct SleepEntryView: View {
    @Bindable private var child: Child
    @Bindable private var sleep: Sleep
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var trackr: Trackr
    @State private var currentDuration: Int = 0
    @State private var showCancelPrompt = false
    private var modelContext: ModelContext
    
    private var timerRunning: Bool {
        return sleep.trackrRunning && trackr.running;
    }
    
    init(sleep: Sleep?, child: Child, in container: ModelContainer) {
        modelContext = ModelContext(container)
        if let sleep = sleep {
            modelContext.autosaveEnabled = false
            self.sleep = (modelContext.model(for: sleep.persistentModelID) as? Sleep)!
        } else {
            self.sleep = Sleep()
        }
        self.child = (modelContext.model(for: child.persistentModelID) as? Child)!
    }
    
    var body: some View {
        VStack {
            Form {
                Section {
                    DatePicker(selection: $sleep.createdAt, in: ...Date(), displayedComponents: .date, label: {
                        Text("Date")
                            .foregroundStyle(Color.gray)
                    })
                    
                    DatePicker(selection: $sleep.createdAt, in: ...Date(), displayedComponents: .hourAndMinute, label: {
                        Text("Time")
                            .foregroundStyle(Color.gray)
                    })
                }
                
                HStack {
                    Spacer()
                    Text("\(humanReadableDuration())")
                        .font(.system(size: 75))
                        .fontWeight(.light)
                    Spacer()
                }
                .listRowSeparator(.hidden)
            }
        }
        .navigationTitle("Sleep")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar() {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: cancelSleep) {
                    Text("Cancel")
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: save) {
                    Text("Save")
                }
                .disabled(!canSave)
            }
            
            ToolbarItem(placement: .bottomBar) {
                HStack(spacing: 0) {
                    Spacer()
                    Button(action: {
                        sleep.trackrRunning = true
                        if sleep.timerStartedAt == nil {
                            sleep.timerStartedAt = Date()
                        }
                        if trackr.initialised {
                            trackr.startTimer(duration: nil)
                        } else {
                            trackr.initTimer(startedAt: Date.now, duration: sleep.duration)
                            trackr.startTimer(duration: sleep.duration)
                        }
                    }) {
                        IconView(size: .small, icon: "play.fill", shadow: false)
                            .opacity(timerRunning ? 0.8 : 1)
                    }
                    .disabled(timerRunning)
                    
                    Button(action: {
                        trackr.pauseTimer()
                        sleep.trackrRunning = false
                        sleep.timerStartedAt = nil
                    }) {
                        IconView(size: .small, icon: "pause.fill", shadow: false)
                            .opacity(timerRunning ? 1 : 0.8)
                    }
                    .disabled(!timerRunning)
                    Spacer()
                }
            }
        }
        .onReceive(trackr.timer) { firedDate in
            if !trackr.running || !trackr.initialised {
                return
            }
            currentDuration = trackr.duration + trackr.durationTotal
            guard let startTime = trackr.startedAt else {
                return
            }
            
            trackr.duration = Int(firedDate.timeIntervalSince(startTime))
        }
        .onAppear {
            if self.sleep.trackrRunning && self.sleep.timerStartedAt != nil {
                trackr.initTimer(startedAt: self.sleep.timerStartedAt!, duration: self.sleep.duration)
                trackr.startTimer(duration: self.sleep.duration)
            } else {
                currentDuration = sleep.duration
            }
        }
        .confirmationDialog("Cancel Sleep", isPresented: $showCancelPrompt) {
            Button("Yes", role: .destructive, action: {
                dismiss()
            })
            Button("No", role: .cancel) { }
        } message: {
            Text("Are you sure you want to cancel this sleep without saving?")
        }
    }
    
    private var canSave: Bool {
        return true
    }
    
    func humanReadableDuration() -> String {
        let totalDuration = self.currentDuration
        let hours = totalDuration / 3600
        let minutes = (totalDuration % 3600) / 60
        let seconds = (totalDuration % 3600) % 60
        if hours > 0 {
            return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        }
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    func cancelSleep() -> Void {
        if modelContext.hasChanges {
            showCancelPrompt.toggle()
        } else {
            trackr.deinitTimer()
            dismiss()
        }
    }
    
    func save() -> Void {
        withAnimation {
            if !timerRunning {
                sleep.duration = currentDuration
                sleep.timerStartedAt = nil
                sleep.trackrRunning = false
            } else {
                sleep.duration = trackr.durationTotal
                sleep.timerStartedAt = trackr.startedAt
                sleep.trackrRunning = true
            }
            
            if let _ = sleep.child {
                try? modelContext.save()
            } else {
                modelContext.insert(sleep)
                child.sleeps?.append(sleep)
            }
            trackr.deinitTimer()
            dismiss()
        }
    }
}

#Preview {
    NavigationStack {
        SleepEntryView(sleep: Sleep(), child: Child(name: "", dob: Date(), gender: ""), in: PreviewData.container)
            .environmentObject(Trackr())
    }
}
