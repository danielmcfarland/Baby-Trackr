//
//  FeedDetailView.swift
//  Baby Trackr
//
//  Created by Daniel McFarland on 23/01/2024.
//

import SwiftUI
import SwiftData

struct FeedDetailView: View {
    @Query var feedQuery: [Feed]
    @State var feed: Feed
    @State var currentDuration: Int = 0
    @State private var showEditFeedSheet = false
    @EnvironmentObject var trackr: Trackr
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        List {
            Section(header: Text("Feed Details")
            ) {
                VStack(alignment: .leading) {
                    Text("Feed Type")
                        .foregroundStyle(Color.gray)
                        .font(.footnote)
                    Text(feed.type.rawValue)
                }
                
                if feed.typeValue == FeedType.bottle.rawValue {
                    VStack(alignment: .leading) {
                        Text("Bottle Type")
                            .foregroundStyle(Color.gray)
                            .font(.footnote)
                        
                        Text(feed.bottleType.rawValue)
                    }
                    
                    VStack(alignment: .leading) {
                        Text("Volume")
                            .foregroundStyle(Color.gray)
                            .font(.footnote)
                        
                        Text("\(feed.value) \(feed.bottleUnit.rawValue)")
                    }
                }
                if feed.typeValue == FeedType.breast.rawValue {
                    VStack(alignment: .leading) {
                        Text("Side")
                            .foregroundStyle(Color.gray)
                            .font(.footnote)
                        
                        Text(feed.breastSide.rawValue)
                    }
                    
                    VStack(alignment: .leading) {
                        Text("Duration")
                            .foregroundStyle(Color.gray)
                            .font(.footnote)
                        
                        HStack {
                            if feed.trackrRunning {
                                Image(systemName: "record.circle")
                                    .foregroundStyle(Color.red)
                                Text(humanReadableDuration)
                            } else {
                                Text(feed.humanReadableDuration)
                            }
                        }
                    }
                }
                
                VStack(alignment: .leading) {
                    Text("Date")
                        .foregroundStyle(Color.gray)
                        .font(.footnote)
                    Text(feed.createdAt, format: Date.FormatStyle(date: .abbreviated, time: .shortened))
                }
            }
        }
        .navigationTitle("Details")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    showEditFeedSheet.toggle()
                }, label: {
                    Text("Edit")
                })
            }
        }
        .sheet(isPresented: $showEditFeedSheet) {
            NavigationStack {
                if let child = feed.child {
                    FeedEntryView(feed: feed, child: child, in: modelContext.container)
                        .interactiveDismissDisabled()
                }
            }
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
        .onChange(of: feedQuery) {
            if feedQuery.count > 0 {
                self.feed = feedQuery.first!
            }
        }
    }
    
    var humanReadableDuration: String {
        let totalDuration = self.currentDuration + self.feed.duration
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
        FeedDetailView(feed: Feed(type: .breast))
            .environmentObject(Trackr())
    }
}
