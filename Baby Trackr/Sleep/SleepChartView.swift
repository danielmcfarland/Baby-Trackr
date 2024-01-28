//
//  SleepChartView.swift
//  Baby Trackr
//
//  Created by Daniel McFarland on 25/01/2024.
//

import SwiftUI
import SwiftData
import Charts

class ChartSleep {
    var date: Date
    var duration: Double
    
    init(date: Date, duration: Double) {
        self.date = date
        self.duration = duration
    }
}

struct SleepChartView: View {
    var child: Child
    var period: ChartPeriod
    var placeholderSleeps: [Sleep] = []
    
    @Query private var sleeps: [Sleep]
    
    init(child: Child, period: ChartPeriod) {
        let id = child.persistentModelID
        
        self._sleeps = Query(filter: #Predicate<Sleep> { sleep in
            sleep.child?.persistentModelID == id &&
            !sleep.trackrRunning
        }, sort: \.createdAt)
        
        self.child = child
        self.period = period
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

        let startHour = Calendar.current.startOfDay(for: startDate)
        if period == .oneDay {
            for hour in 0..<24 {
                if let date = Calendar.current.date(byAdding: .hour, value: hour, to: startHour) {
                    let sleep = Sleep()
                    sleep.duration = 0
                    sleep.createdAt = date
                    data.append(sleep)
                }
            }
        }

        data.append(contentsOf: sleeps)
        let chartSleeps = Dictionary(grouping: data, by: { sleep in
            var components = [
                Calendar.Component.day,
                Calendar.Component.month,
                Calendar.Component.year,
            ]
            if period == .oneDay {
                components = [
                    Calendar.Component.hour,
                    Calendar.Component.day,
                    Calendar.Component.month,
                    Calendar.Component.year,
                ]
            }
            
            return Calendar.current.dateComponents(Set(components), from: sleep.createdAt)
        }).map { dateComponents, sleeps in
            let duration = sleeps.map { sleep in
                return Double(sleep.duration)
            }.reduce(0, +) / 3600
            
            let calendar = Calendar(identifier: .gregorian)
            var components = DateComponents(year: dateComponents.year, month: dateComponents.month, day: dateComponents.day, hour: dateComponents.hour)
            switch period {
            case .oneDay:
                components = DateComponents(year: dateComponents.year, month: dateComponents.month, day: dateComponents.day, hour: dateComponents.hour)
                break
            case .sevenDays, .twentyEightDays:
                components = DateComponents(year: dateComponents.year, month: dateComponents.month, day: dateComponents.day)
                break
            case .allTime:
                components = DateComponents(year: dateComponents.year, month: dateComponents.month)
                break
            }

            let date = calendar.date(from: components)!
            
            return ChartSleep(date: date, duration: duration)
        }
        
        return chartSleeps
    }
    
    var chartUnit: Calendar.Component {
        switch period {
        case .oneDay:
            return .hour
        case .sevenDays, .twentyEightDays:
            return .day
        case .allTime:
            return .month
        }
    }
    
    var body: some View {
        Chart(chartSleeps, id: \.date) { element in
             BarMark(
                x: .value("Day", element.date, unit: chartUnit),
                y: .value("Total Sleep", element.duration)
             )
             .cornerRadius(5)
         }
         .chartScrollableAxes(.horizontal)
         .chartXVisibleDomain(length: period.numberOfDays * 24 * 60 * 60)
         .chartScrollPosition(initialX: Date.now.timeIntervalSince1970)
         .chartScrollTargetBehavior(
            .valueAligned(
                matching: period == .oneDay ? DateComponents(minute: 0) : DateComponents(hour: 0),
                majorAlignment: .matching(period == .oneDay ? DateComponents(hour: 0) : DateComponents(day: 0))
            )
         )
    }
}

#Preview {
    SingleItemPreview<Child> { child in
        SleepChartView(child: child, period: .sevenDays)
    }
    .modelContainer(PreviewData.container)
    .environmentObject(Trackr())
}
