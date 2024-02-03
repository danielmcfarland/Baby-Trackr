//
//  SleepChartView.swift
//  Baby Trackr
//
//  Created by Daniel McFarland on 25/01/2024.
//

import SwiftUI
import SwiftData
import Charts

struct SleepChartView: View {
    var child: Child
    var period: ChartPeriod
    var placeholderSleeps: [Sleep] = []
    
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
    
    @Query private var sleeps: [Sleep]
    var chartRange: Int
    
    init(child: Child, period: ChartPeriod) {
        let id = child.persistentModelID
        
        self._sleeps = Query(filter: #Predicate<Sleep> { sleep in
            sleep.child?.persistentModelID == id &&
            !sleep.trackrRunning
        }, sort: \.createdAt, order: .reverse)
        
        self.child = child
        self.period = period
        self.chartRange = period.numberOfDays * 24 * 60 * 60
    }
    
    var chartSleeps: [ChartSleep] {
        var data: [Sleep] = []
        let startDate = period.startDate
        let startOfPeriodSleep = Sleep()
        startOfPeriodSleep.duration = 0
        startOfPeriodSleep.createdAt = startDate
        data.append(startOfPeriodSleep)
        
        let endOfTodaySleep = Sleep()
        endOfTodaySleep.duration = 0
        endOfTodaySleep.createdAt = Calendar.current.startOfDay(for: Date.now)
        data.append(endOfTodaySleep)

        data.append(contentsOf: sleeps)
        let chartSleeps = Dictionary(grouping: data, by: { sleep in
            let components = [
                Calendar.Component.day,
                Calendar.Component.month,
                Calendar.Component.year,
            ]
            return Calendar.current.dateComponents(Set(components), from: sleep.createdAt)
        }).map { dateComponents, sleeps in
            let duration = sleeps.map { sleep in
                return Double(sleep.duration)
            }.reduce(0, +) / 3600
            
            let components = DateComponents(year: dateComponents.year, month: dateComponents.month, day: dateComponents.day)
            
            let date = Calendar.current.date(from: components)!
            
            return ChartSleep(date: date, duration: duration)
        }
        
        return chartSleeps
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .center) {
                IconView(size: .small, icon: "moon.stars.fill")
                VStack(alignment: .leading, spacing: 0) {
                    Text("Sleep")
                        .foregroundStyle(Color.gray)
                        .font(.footnote)
                        .fontWeight(.semibold)
                    Text("\(scrollChartRange)")
                        .fontWeight(.semibold)
                }
            }
            .padding(.bottom, 10)
            Chart(chartSleeps, id: \.date) { element in
                BarMark(
                    x: .value("Day", element.date, unit: .day),
                    y: .value("Total Sleep", element.duration)
                )
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
}

#Preview {
    SingleItemPreview<Child> { child in
        SleepChartView(child: child, period: .sevenDays)
    }
    .modelContainer(PreviewData.container)
    .environmentObject(Trackr())
}
