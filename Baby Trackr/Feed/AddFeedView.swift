//
//  AddFeedView.swift
//  Baby Trackr
//
//  Created by Daniel McFarland on 17/01/2024.
//

import SwiftUI

struct AddFeedView: View {
    enum FocusedField {
        case measurement
    }
    
    @EnvironmentObject var trackr: Trackr
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) var dismiss
    @State var feed: Feed
    var feedFormData: FeedFormData
    @State var currentDuration: Int = 0
    @State private var showCancelPrompt = false
    @FocusState private var focusedField: FocusedField?
    var child: Child
    var toolbarVisible: Visibility = .visible
    
    init(feed: Feed, child: Child) {
        self._feed = State(initialValue: feed)
        self.child = child
        
        let feedFormData = FeedFormData()

        feedFormData.type = feed.type
        feedFormData.trackrRunning = feed.trackrRunning
        feedFormData.timerStartedAt = feed.timerStartedAt
        feedFormData.duration = feed.duration
        feedFormData.createdAt = feed.createdAt
        feedFormData.breastSide = feed.breastSide
        feedFormData.bottleType = feed.bottleType
        feedFormData.bottleSize = feed.bottleSize
        
        self.feedFormData = feedFormData
    }
    
    var body: some View {
        VStack {
            Form {
                Section {
                    DatePicker(selection: $feed.createdAt, in: ...Date(), displayedComponents: .date, label: {
                        Text("Date")
                            .foregroundStyle(Color.gray)
                    })
                    
                    DatePicker(selection: $feed.createdAt, in: ...Date(), displayedComponents: .hourAndMinute, label: {
                        Text("Time")
                            .foregroundStyle(Color.gray)
                    })
                    
                    Picker("Type", selection: $feed.typeValue) {
                        ForEach(FeedType.allCases) { feed in
                            Text(feed.rawValue).tag(feed.rawValue)
                        }
                    }
                    .foregroundStyle(Color.gray)
                }
                
                if feed.typeValue == FeedType.bottle.rawValue {
                    Section {
                        Picker("Bottle Type", selection: $feed.bottleTypeValue) {
                            ForEach(BottleType.allCases) { bottleType in
                                Text(bottleType.rawValue).tag(bottleType.rawValue)
                            }
                        }
                        .foregroundStyle(Color.gray)
                        
                        Picker("Bottle Size", selection: $feed.bottleSizeValue) {
                            ForEach(BottleSize.allCases) { bottleSize in
                                Text(bottleSize.rawValue).tag(bottleSize.rawValue)
                            }
                        }
                        .foregroundStyle(Color.gray)
                    }
                }
                
                if feed.typeValue == FeedType.breast.rawValue {
                    Section {
                        Picker("Side", selection: $feed.breastSideValue) {
                            ForEach(BreastSide.allCases) { breastSide in
                                Text(breastSide.rawValue).tag(breastSide.rawValue)
                            }
                        }
                        .foregroundStyle(Color.gray)
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
        }
        .navigationTitle("Feed")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar() {
            if toolbarVisible == .visible {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        cancelFeed()
                    }) {
                        Text("Cancel")
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        save()
                    }) {
                        Text("Save")
                    }
                    .disabled(!canSave)
                }
            }
            
            ToolbarItem(placement: .bottomBar) {
                if feed.typeValue == FeedType.breast.rawValue {
                    HStack(spacing: 0) {
                        Spacer()
                        Button(action: {
                            feed.trackrRunning = true
                            if feed.timerStartedAt == nil {
                                feed.timerStartedAt = Date()
                            }
                        }) {
                            IconView(size: .small, icon: "play.fill", shadow: false)
                                .opacity(feed.trackrRunning ? 0.8 : 1)
                        }
                        .disabled(feed.trackrRunning)
                        
                        Button(action: {
                            feed.trackrRunning = false
                            feed.duration = feed.duration + currentDuration
                            feed.timerStartedAt = nil
                            currentDuration = 0
                        }) {
                            IconView(size: .small, icon: "pause.fill", shadow: false)
                                .opacity(feed.trackrRunning ? 1 : 0.8)
                        }
                        .disabled(!feed.trackrRunning)
                        Spacer()
                    }
                }
            }
        }
        .onAppear {
            focusedField = .measurement
        }
        .onReceive(trackr.timer) { firedDate in
            if !feed.trackrRunning {
                return
            }
            guard let startTime = feed.timerStartedAt else {
                return
            }
            
            currentDuration = Int(firedDate.timeIntervalSince(startTime))
        }
        .confirmationDialog("Cancel Feed", isPresented: $showCancelPrompt) {
            Button("Yes", action: dismiss.callAsFunction)
            Button("No", role: .cancel) { }
        } message: {
            Text("Are you sure you want to cancel this feed without saving?")
        }
    }
    
    var canSave: Bool {
        return true
    }
    
    func humanReadableDuration() -> String {
        let totalDuration = self.currentDuration + self.feed.duration
        let hours = totalDuration / 3600
        let minutes = (totalDuration % 3600) / 60
        let seconds = (totalDuration % 3600) % 60
        if hours > 0 {
            return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        }
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    func cancelFeed() -> Void {
        showCancelPrompt.toggle()
    }
    
    func save() -> Void {
        withAnimation {
//            feed.typeValue = feedFormData.type.rawValue
//            feed.trackrRunning = feedFormData.trackrRunning
//            feed.timerStartedAt = feedFormData.timerStartedAt
//            feed.duration = feedFormData.duration
//            feed.createdAt = feedFormData.createdAt
//            feed.breastSideValue = feedFormData.breastSide.rawValue
//            feed.bottleTypeValue = feedFormData.bottleType.rawValue
//            feed.bottleSizeValue = feedFormData.bottleSize.rawValue
            
            if let _ = feed.child {
                do {
                    try modelContext.save()
                } catch {
                    print("Error updating feed \(error)")
                }
            } else {
                modelContext.insert(feed)
                child.feeds?.append(feed)
            }
            dismiss()
        }
    }
}

#Preview {
    NavigationStack {
        AddFeedView(feed: Feed(type: FeedType.breast), child: Child(name: "", dob: Date(), gender: ""))
            .environmentObject(Trackr())
    }
}
