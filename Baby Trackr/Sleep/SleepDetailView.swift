//
//  SleepDetailView.swift
//  Baby Trackr
//
//  Created by Daniel McFarland on 24/01/2024.
//

import SwiftUI
import SwiftData

struct SleepDetailView: View {
    @Query var sleepQuery: [Sleep]
    @State var sleep: Sleep
    @State var currentDuration: Int = 0
    @State private var showEditSleepSheet = false
    @EnvironmentObject var trackr: Trackr
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        List {
            Section(header: Text("Sleep Details")
            ) {
                VStack(alignment: .leading) {
                    Text("Date")
                        .foregroundStyle(Color.gray)
                        .font(.footnote)
                    Text(sleep.createdAt, format: Date.FormatStyle(date: .abbreviated, time: .shortened))
                }
                
                VStack(alignment: .leading) {
                    Text("Duration")
                        .foregroundStyle(Color.gray)
                        .font(.footnote)
                    
                    HStack {
                        if sleep.trackrRunning {
                            Image(systemName: "record.circle")
                                .foregroundStyle(Color.red)
                            Text(humanReadableDuration)
                        } else {
                            Text(sleep.humanReadableDuration)
                        }
                    }
                }
            }
        }
        .navigationTitle("Details")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    showEditSleepSheet.toggle()
                }, label: {
                    Text("Edit")
                })
            }
        }
        .sheet(isPresented: $showEditSleepSheet) {
            NavigationStack {
                if let child = sleep.child {
                    SleepEntryView(sleep: sleep, child: child, in: modelContext.container)
                        .interactiveDismissDisabled()
                }
            }
        }
        .onReceive(trackr.timer) { firedDate in
            if !sleep.trackrRunning {
                return
            }
            guard let startTime = sleep.timerStartedAt else {
                return
            }
            
            currentDuration = Int(firedDate.timeIntervalSince(startTime))
        }
        .onChange(of: sleepQuery) {
            if sleepQuery.count > 0 {
                self.sleep = sleepQuery.first!
            }
        }
    }
    
    var humanReadableDuration: String {
        let totalDuration = self.currentDuration + self.sleep.duration
        let hours = totalDuration / 3600
        let minutes = (totalDuration % 3600) / 60
        let seconds = (totalDuration % 3600) % 60
        if hours > 0 {
            return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        }
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

#Preview {
    NavigationStack {
        SleepDetailView(sleep: Sleep())
            .environmentObject(Trackr())
    }
}
