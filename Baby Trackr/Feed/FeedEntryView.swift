//
//  AddFeedView.swift
//  Baby Trackr
//
//  Created by Daniel McFarland on 17/01/2024.
//

import SwiftUI
import SwiftData

struct FeedEntryView: View {
    
    enum FocusedField {
        case value
    }
    
    @Bindable private var child: Child
    @Bindable private var feed: Feed
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var trackr: Trackr
    @FocusState private var focusedField: FocusedField?
    @State private var bottleVolume: Int?
    @State private var currentDuration: Int = 0
    @State private var showCancelPrompt = false
    private var modelContext: ModelContext
    
    private var timerRunning: Bool {
        return feed.trackrRunning && trackr.running;
    }
    
    init(feed: Feed?, child: Child, in container: ModelContainer) {
        modelContext = ModelContext(container)
        if let feed = feed {
            modelContext.autosaveEnabled = false
            self.feed = (modelContext.model(for: feed.persistentModelID) as? Feed)!
        } else {
            self.feed = Feed(type: .bottle)
        }
        self.child = (modelContext.model(for: child.persistentModelID) as? Child)!
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
                    Section(header: Text("").padding(.top, -10), footer: Text("").padding(.bottom, -10)) {
                        HStack {
                            ForEach(BottleSize.allCases) { bottleSize in
                                ZStack {
                                    RoundedRectangle(cornerRadius: 20)
                                        .foregroundStyle(Gradient(colors: [
                                            Color.indigo.opacity(0.7),
                                            Color.indigo.opacity(0.9),
                                        ]))
                                    
                                    Text("\(bottleSize.rawValue)")
                                        .font(.callout)
                                        .foregroundStyle(Color.white)
                                }
                                .onTapGesture {
                                    bottleVolume = bottleSize.value
                                    feed.bottleUnitValue = bottleSize.units.rawValue
                                }
                            }
                        }
                        .alignmentGuide(.listRowSeparatorLeading) { _ in
                            0
                        }
                        .listRowBackground(Color.clear)
                    }
                    .listSectionSpacing(0)

                    Section {
                        LabeledContent {
                            TextField("", value: $bottleVolume, format: .number)
                                .keyboardType(.decimalPad)
                                .focused($focusedField, equals: .value)
                                .multilineTextAlignment(.trailing)
                                .foregroundStyle(Color.gray)
                                .onChange(of: bottleVolume) {
                                    guard let bottleVolume = bottleVolume else {
                                        feed.value = 0
                                        return
                                    }
                                    
                                    feed.value = bottleVolume
                                }
                        } label: {
                            Text("Volume")
                                .foregroundStyle(Color.gray)
                        }
                        
                        Picker("Unit", selection: $feed.bottleUnitValue) {
                            ForEach(BottleUnit.allCases) { bottleUnit in
                                Text(bottleUnit.rawValue).tag(bottleUnit.rawValue)
                            }
                        }
                        .foregroundStyle(Color.gray)
                        
                        Picker("Bottle Type", selection: $feed.bottleTypeValue) {
                            ForEach(BottleType.allCases) { bottleType in
                                Text(bottleType.rawValue).tag(bottleType.rawValue)
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
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: cancelFeed) {
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
                if feed.typeValue == FeedType.breast.rawValue {
                    HStack(spacing: 0) {
                        Spacer()
                        Button(action: {
                            feed.trackrRunning = true
                            if feed.timerStartedAt == nil {
                                feed.timerStartedAt = Date()
                            }
                            if trackr.initialised {
                                trackr.startTimer(duration: nil)
                            } else {
                                trackr.initTimer(startedAt: Date.now, duration: feed.duration)
                                trackr.startTimer(duration: feed.duration)
                            }
                        }) {
                            IconView(size: .small, icon: "play.fill", shadow: false)
                                .opacity(timerRunning ? 0.8 : 1)
                        }
                        .disabled(timerRunning)
                        
                        Button(action: {
                            trackr.pauseTimer()
                            feed.trackrRunning = false
                            feed.timerStartedAt = nil
                        }) {
                            IconView(size: .small, icon: "pause.fill", shadow: false)
                                .opacity(timerRunning ? 1 : 0.8)
                        }
                        .disabled(!timerRunning)
                        Spacer()
                    }
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
            if self.feed.trackrRunning && self.feed.timerStartedAt != nil {
                trackr.initTimer(startedAt: self.feed.timerStartedAt!, duration: self.feed.duration)
                trackr.startTimer(duration: self.feed.duration)
            } else {
                currentDuration = feed.duration
            }
            if self.feed.type == .bottle {
                focusedField = .value
                if self.feed.value != 0 {
                    bottleVolume = self.feed.value
                }
            }
        }
        .confirmationDialog("Cancel Feed", isPresented: $showCancelPrompt) {
            Button("Yes", role: .destructive, action: {
                dismiss()
            })
            Button("No", role: .cancel) { }
        } message: {
            Text("Are you sure you want to cancel this feed without saving?")
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
    
    func cancelFeed() -> Void {
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
                feed.duration = currentDuration
                feed.timerStartedAt = nil
                feed.trackrRunning = false
            } else {
                feed.duration = trackr.durationTotal
                feed.timerStartedAt = trackr.startedAt
                feed.trackrRunning = true
            }
            
            if let _ = feed.child {
                try? modelContext.save()
            } else {
                modelContext.insert(feed)
                child.feeds?.append(feed)
            }
            trackr.deinitTimer()
            dismiss()
        }
    }
}

#Preview {
    NavigationStack {
        FeedEntryView(feed: Feed(type: FeedType.bottle), child: Child(name: "", dob: Date(), gender: ""), in: PreviewData.container)
            .environmentObject(Trackr())
    }
}
