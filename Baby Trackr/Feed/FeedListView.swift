//
//  FeedListView.swift
//  Baby Trackr
//
//  Created by Daniel McFarland on 17/01/2024.
//

import SwiftUI
import SwiftData

struct FeedListView: View {
    var child: Child
    var feedType: FeedType
    
    @Query private var feeds: [Feed]
    
    @State var period: ChartPeriod = ChartPeriod.sevenDays
    
    init(child: Child, feedType: FeedType) {
        let id = child.persistentModelID
        
        self._feeds = Query(filter: #Predicate<Feed> { feed in
            feed.child?.persistentModelID == id &&
            feed.typeValue == feedType.rawValue
        }, sort: \.createdAt, order: .reverse)
        
        self.child = child
        self.feedType = feedType
    }
    
    var body: some View {
        List {
            Picker("Chart Period", selection: $period) {
                ForEach(ChartPeriod.allCases) { period in
                    Text(period.rawValue).tag(period)
                }
            }
            .pickerStyle(.segmented)
            .padding(0)
            .listRowInsets(.none)
            .listRowBackground(Color.clear)
            .listRowSpacing(0)
            .listRowSeparator(.hidden)
            
            Group {
                if feedType == .breast {
                    FeedChartView(child: child, feedType: feedType, period: period)
                }
                
                if feedType == .bottle {
                    FeedBarView(child: child, feedType: feedType, period: period)
                }
            }
            .listRowInsets(.none)
            .listRowBackground(Color.clear)
            .listRowSpacing(0)
            .listRowSeparator(.hidden)
            .padding(.bottom, -20)
            
            Section {
                ForEach(feeds) { feed in
                    NavigationLink(value: feed) {
                        HStack {
                            if feed.type == .bottle {
                                Text("\(feed.bottleSize.rawValue)")
                            } else if feed.type == .breast && !feed.trackrRunning {
                                Text("\(feed.humanReadableDuration)")
                            } else if feed.type == .breast && feed.trackrRunning {
                                HStack {
                                    Image(systemName: "record.circle")
                                        .foregroundStyle(Color.red)
                                    Text("In Progress")
                                }
                            }
                            Spacer()
                            Text(feed.createdAt, format: Date.FormatStyle(date: .abbreviated, time: .shortened))
                                .foregroundStyle(Color.gray)
                        }
                    }
                }
            }
        }
        .padding(.top, -35)
        .listStyle(DefaultListStyle())
    }
}

#Preview {
    NavigationStack {
        FeedListView(child: Child(name: "Name", dob: Date(), gender: ""), feedType: .breast)
    }
}
