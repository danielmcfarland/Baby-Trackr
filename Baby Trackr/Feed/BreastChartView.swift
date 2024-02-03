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
        let startOfPeriodSleep = Feed(type: .breast)
        startOfPeriodSleep.duration = 0
        startOfPeriodSleep.createdAt = startDate
        data.append(startOfPeriodSleep)
        
        let endOfTodaySleep = Feed(type: .breast)
        endOfTodaySleep.duration = 0
        endOfTodaySleep.createdAt = Calendar.current.startOfDay(for: Date.now)
        data.append(endOfTodaySleep)

        data.append(contentsOf: feeds)
        
        var chartFeeds: [ChartFeed] = []
        
        BreastSide.allCases.forEach { breastSide in
            let items = getBreastSide(data: data, breastSide: breastSide)
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
                .foregroundStyle(by: .value("Breast Side", element.breastSide.rawValue))
                .position(by: .value("Breast Side", element.breastSide.rawValue))
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
    
    func getBreastSide(data: [Feed], breastSide: BreastSide) -> [ChartFeed] {
        
        let feeds = data.filter { feed in
            return feed.breastSide == breastSide
        }
        
        return Dictionary(grouping: feeds, by: { sleep in
            let components = [
                Calendar.Component.day,
                Calendar.Component.month,
                Calendar.Component.year,
            ]
            return Calendar.current.dateComponents(Set(components), from: sleep.createdAt)
        }).map { dateComponents, feeds in
            let duration = feeds.map { sleep in
                return Double(sleep.duration)
            }.reduce(0, +) / 3600
            
            let components = DateComponents(year: dateComponents.year, month: dateComponents.month, day: dateComponents.day)
            
            let date = Calendar.current.date(from: components)!
            
            return ChartFeed(date: date, duration: duration, breastSide: breastSide, bottleType: .unknown)
        }
    }
}

#Preview {
    SingleItemPreview<Child> { child in
        NavigationStack {
            BreastChartView(child: child, feedType: .breast, period: .sevenDays)
        }
    }
    .modelContainer(PreviewData.container)
    .environmentObject(Trackr())
}
