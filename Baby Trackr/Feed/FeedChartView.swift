//
//  FeedChartView.swift
//  Baby Trackr
//
//  Created by Daniel McFarland on 22/01/2024.
//

import SwiftUI
import SwiftData
import Charts

struct FeedChartView: View {
    var child: Child
    var feedType: FeedType
    var period: ChartPeriod
    
    @Query private var feeds: [Feed]
    
    init(child: Child, feedType: FeedType, period: ChartPeriod) {
        let id = child.persistentModelID
        let periodDate: Date = period.periodDate
        
        self._feeds = Query(filter: #Predicate<Feed> { feed in
            feed.child?.persistentModelID == id &&
            feed.typeValue == feedType.rawValue &&
            feed.createdAt > periodDate
        })
        
        self.child = child
        self.feedType = feedType
        self.period = period
    }
    
    var chartFeeds: [ChartFeed] {
        return Dictionary(grouping: feeds, by: { feed in
            feed.breastSide
        }).map { breastSide, feeds in
            let duration = feeds.map { feed in
                return feed.duration
            }.reduce(0, +)
            return ChartFeed(duration: duration, breastSide: breastSide)
        }.sorted {
            $0.breastSide.rawValue < $1.breastSide.rawValue
        }
    }
    
    var body: some View {
        Chart(chartFeeds, id: \.breastSide) { feed in
            SectorMark(
                angle: .value("Duration", feed.duration),
                innerRadius: .ratio(0.618),
                angularInset: 1.5
            )
            .cornerRadius(5)
            .foregroundStyle(by: .value("Side", feed.breastSide.rawValue))
        }
        .chartXAxis(.hidden)
        .padding()
        .frame(height: 250)
        .animation(.default, value: chartFeeds)
    }
}

#Preview {
    FeedChartView(child: Child(name: "", dob: Date.distantPast, gender: ""), feedType: .breast, period: .sevenDays)
}
