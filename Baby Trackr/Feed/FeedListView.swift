//
//  FeedListView.swift
//  Baby Trackr
//
//  Created by Daniel McFarland on 17/01/2024.
//

import SwiftUI
import SwiftData
import Charts

struct FeedListView: View {
    var child: Child
    var feedType: FeedType
    
    @Query private var feeds: [Feed]
    
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
        VStack {
            if feedType == .breast {
                Chart(feeds, id: \.breastSide) { feed in
                    BarMark(
                        x: .value("Time", feed.duration),
                            stacking: .normalized
                        )
                    .foregroundStyle(by: .value("Side", feed.breastSide.rawValue))
                }
                .chartXAxis(.hidden)
                .padding()
                .frame(height: 100)
            }
            List {
                Section(header: Text("\(feedType.rawValue) Feeds")) {
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
        }
    }
}

#Preview {
    NavigationStack {
        FeedListView(child: Child(name: "Name", dob: Date(), gender: ""), feedType: .breast)
    }
}
