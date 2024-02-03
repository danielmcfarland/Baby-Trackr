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
    
    @State private var scrollPosition: Date = Date(timeInterval: -Double(7 * 24 * 60 * 60), since: Calendar.current.startOfDay(for: Date(timeIntervalSinceNow: Double(24 * 60 * 60))))

    var startRangeDate: Date {
        return scrollPosition.addingTimeInterval(60 * 60 * 12)
    }
    
    var endRangeDate: Date {
        return Date(timeInterval: Double(6 * 24 * 60 * 60), since: startRangeDate)
    }
    
    var scrollChartRange: String {
        let dateRange = self.startRangeDate..<self.endRangeDate
        return dateRange.formatted(.interval.day().month(.abbreviated).year())
    }
    
    @Query private var feeds: [Feed]
    var chartRange: Int
    
    init(child: Child, feedType: FeedType, period: ChartPeriod) {
        let id = child.persistentModelID
        
        self._feeds = Query(filter: #Predicate<Feed> { feed in
            feed.child?.persistentModelID == id &&
            feed.typeValue == feedType.rawValue &&
            !feed.trackrRunning
        })
        
        self.child = child
        self.feedType = feedType
        self.period = period
        self.chartRange = period.numberOfDays * 24 * 60 * 60
    }
    
    var chartFeeds: [ChartFeed] {
        var data: [Feed] = []
        let startDate = period.startDate
        let startOfPeriodSleep = Feed(type: .bottle)
        startOfPeriodSleep.value = 0
        startOfPeriodSleep.createdAt = startDate
        data.append(startOfPeriodSleep)
        
        let endOfTodaySleep = Feed(type: .bottle)
        endOfTodaySleep.value = 0
        endOfTodaySleep.createdAt = Calendar.current.startOfDay(for: Date.now)
        data.append(endOfTodaySleep)

        data.append(contentsOf: feeds)
        
        var chartFeeds: [ChartFeed] = []
        
        BottleType.allCases.forEach { bottleType in
            let items = getBottleType(data: data, bottleType: bottleType)
            chartFeeds.append(contentsOf: items)
        }
        
        return chartFeeds
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .center) {
                IconView(size: .small, icon: "waterbottle.fill")
                VStack(alignment: .leading, spacing: 0) {
                    Text("Feed")
                        .foregroundStyle(Color.gray)
                        .font(.footnote)
                        .fontWeight(.semibold)
                    Text("\(scrollChartRange)")
                        .fontWeight(.semibold)
                }
            }
            .padding(.bottom, 10)

            Chart(chartFeeds, id: \.date) { element in
                BarMark(
                    x: .value("Day", element.date, unit: .day),
                    y: .value("Total", element.value)
                )
                .foregroundStyle(by: .value("Bottle Type", element.bottleType.rawValue))
                .position(by: .value("Bottle Type", element.bottleType.rawValue))
                .cornerRadius(5)
            }
            .chartXAxis {
                AxisMarks(values: .stride(by: .day, count: 1)) { value in
                    AxisValueLabel(format: .dateTime.weekday())
                    AxisGridLine()
                    AxisTick()
                }
            }
            .chartScrollableAxes(.horizontal)
            .chartXVisibleDomain(length: chartRange)
            .chartScrollPosition(x: $scrollPosition)
            .chartScrollTargetBehavior(
                .valueAligned(
                    unit: 24 * 60 * 60,
                    majorAlignment: .unit(1)
                )
            )
        }
    }
    
    func getBottleType(data: [Feed], bottleType: BottleType) -> [ChartFeed] {
        
        let feeds = data.filter { feed in
            return feed.bottleType == bottleType
        }
        
        return Dictionary(grouping: feeds, by: { sleep in
            let components = [
                Calendar.Component.day,
                Calendar.Component.month,
                Calendar.Component.year,
            ]
            return Calendar.current.dateComponents(Set(components), from: sleep.createdAt)
        }).map { dateComponents, feeds in
            let value = feeds.map { feed in
                switch feed.bottleUnit {
                case .ml:
                    return Double(feed.value)
                case .oz:
                    return Double(feed.value) * 28.41
                }
            }.reduce(Double(0), +)
            
            let components = DateComponents(year: dateComponents.year, month: dateComponents.month, day: dateComponents.day)
            
            let date = Calendar.current.date(from: components)!
            
            return ChartFeed(date: date, duration: value, breastSide: .unknown, bottleType: bottleType)
        }
    }
}

#Preview {
    SingleItemPreview<Child> { child in
        NavigationStack {
            BottleChartView(child: child, feedType: .bottle, period: .sevenDays)
        }
    }
    .modelContainer(PreviewData.container)
    .environmentObject(Trackr())
}
