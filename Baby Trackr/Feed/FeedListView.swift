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
            if feedType == .breast {
                BreastChartView(child: child, feedType: feedType, period: period)
                    .listRowBackground(Color.clear)
                    .listRowSpacing(0)
                    .listRowSeparator(.hidden)
                    .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                    .frame(height: 275)
            }
            
            if feedType == .bottle {
                BottleChartView(child: child, feedType: feedType, period: period)
                    .listRowBackground(Color.clear)
                    .listRowSpacing(0)
                    .listRowSeparator(.hidden)
                    .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                    .frame(height: 275)
            }
            
            Section {
                ForEach(feeds) { feed in
                    NavigationLink(value: feed) {
                        HStack {
                            if feed.type == .bottle {
                                Text("\(feed.value) \(feed.bottleUnit.rawValue)")
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
        .listStyle(DefaultListStyle())
    }
}

#Preview {
    NavigationStack {
        FeedListView(child: Child(name: "Name", dob: Date(), gender: ""), feedType: .breast)
    }
}
