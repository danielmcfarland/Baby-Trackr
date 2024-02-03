//
//  FeedChartView.swift
//  Baby Trackr
//
//  Created by Daniel McFarland on 22/01/2024.
//

import SwiftUI
import SwiftData
import Charts

struct BreastChartView: View {
    var child: Child
    var feedType: FeedType
    var period: ChartPeriod
    var placeholderFeeds: [Feed] = []
    
    @Query private var feeds: [Feed]
    
    var startRangeDate: Date {
        return Date.now.addingTimeInterval(-Double(7 * 24 * 60 * 60))
    }
    
    var endRangeDate: Date {
        return Date.now
    }
    
    var scrollChartRange: String {
        let dateRange = self.startRangeDate..<self.endRangeDate
        return dateRange.formatted(.interval.day().month(.abbreviated).year())
    }
    
    init(child: Child, feedType: FeedType, period: ChartPeriod) {
        let id = child.persistentModelID
        let periodDate: Date = period.startDate
        
        self._feeds = Query(filter: #Predicate<Feed> { feed in
            feed.child?.persistentModelID == id &&
            feed.typeValue == feedType.rawValue &&
            feed.createdAt > periodDate &&
            !feed.trackrRunning
        })
        
        self.child = child
        self.feedType = feedType
        self.period = period
        
        BreastSide.allCases.forEach { side in
            let feed = Feed(type: .bottle)
            feed.duration = 0
            feed.breastSideValue = side.rawValue
            self.placeholderFeeds.append(feed)
        }
    }
    
    var chartFeeds: [ChartFeed] {
        var data = placeholderFeeds
        data.append(contentsOf: feeds)
        
        return Dictionary(grouping: data, by: { feed in
            feed.breastSide
        }).map { breastSide, feeds in
            let duration = feeds.map { feed in
                return Double(feed.duration)
            }.reduce(0, +)
            return ChartFeed(duration: duration, breastSide: breastSide, bottleType: .unknown)
        }.sorted {
            $0.breastSide.rawValue < $1.breastSide.rawValue
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Feeds")
                .foregroundStyle(Color.gray)
                .font(.footnote)
                .fontWeight(.semibold)
            Text("\(scrollChartRange)")
                .fontWeight(.semibold)
                .padding(.bottom, 10)
            Chart(chartFeeds, id: \.breastSide) { feed in
                SectorMark(
                    angle: .value("Duration", feed.value),
                    innerRadius: .ratio(0.618),
                    angularInset: 1.5
                )
                .cornerRadius(5)
                .foregroundStyle(by: .value("Side", feed.breastSide.rawValue))
            }
            .chartXAxis(.hidden)
            .padding()
            .padding(.bottom, 0)
            .frame(height: 250)
            .animation(.default, value: chartFeeds)
        }
    }
}

#Preview {
    BreastChartView(child: Child(name: "", dob: Date.distantPast, gender: ""), feedType: .breast, period: .sevenDays)
}
