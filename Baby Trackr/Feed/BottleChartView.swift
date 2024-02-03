//
//  FeedBarView.swift
//  Baby Trackr
//
//  Created by Daniel McFarland on 23/01/2024.
//

import SwiftUI
import SwiftData
import Charts

struct BottleChartView: View {
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
        
        BottleType.allCases.forEach { bottleType in
            let feed = Feed(type: .bottle)
            feed.duration = 0
            feed.bottleTypeValue = bottleType.rawValue
            self.placeholderFeeds.append(feed)
        }
    }
    
    var chartFeeds: [ChartFeed] {
        var data = placeholderFeeds
        data.append(contentsOf: feeds)
        
        return Dictionary(grouping: data, by: { feed in
            feed.bottleType
        }).map { bottleType, feeds in
            let value = feeds.map { feed in
                switch feed.bottleUnit {
                case .ml:
                    return Double(feed.value)
                case .oz:
                    return Double(feed.value) * 28.41
                }
            }.reduce(Double(0), +)
            return ChartFeed(duration: value, breastSide: .unknown, bottleType: bottleType)
        }.sorted {
            $0.bottleType.rawValue < $1.bottleType.rawValue
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
            Chart(chartFeeds, id: \.bottleType) { feed in
                SectorMark(
                    angle: .value("Volume", feed.value),
                    innerRadius: .ratio(0.618),
                    angularInset: 1.5
                )
                .cornerRadius(5)
                .foregroundStyle(by: .value("Side", feed.bottleType.rawValue))
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
    BottleChartView(child: Child(name: "", dob: Date.distantPast, gender: ""), feedType: .breast, period: .sevenDays)
}
