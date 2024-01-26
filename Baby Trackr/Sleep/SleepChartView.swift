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
        let periodDate: Date = period.periodDate
        
        self._sleeps = Query(filter: #Predicate<Sleep> { sleep in
            sleep.child?.persistentModelID == id &&
            sleep.createdAt > periodDate &&
            !sleep.trackrRunning
        }, sort: \.createdAt)
        
        self.child = child
        self.period = period
    }
    
    var chartSleeps: [ChartSleep] {
        var data: [Sleep] = []
        var startDate = Date()
        if let firstSleep = sleeps.first {
            startDate = firstSleep.createdAt
        }
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
        } else {
            let numberOfDays = Calendar.current.dateComponents([.day], from: startDate, to: Date())
            for day in 0...(numberOfDays.day ?? 30) {
                if let date = Calendar.current.date(byAdding: .day, value: day, to: startHour) {
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
            var components = DateComponents(year: dateComponents.year, month: dateComponents.month, day: dateComponents.day)
            if period == .oneDay {
                components = DateComponents(year: dateComponents.year, month: dateComponents.month, day: dateComponents.day, hour: dateComponents.hour)
            }
            let date = calendar.date(from: components)!
            
            return ChartSleep(date: date, duration: duration)
        }
        
        return chartSleeps
    }
    
    var chartUnit: Calendar.Component {
        return period == .oneDay ? .hour : .day
    }
    
    var body: some View {
        Chart(chartSleeps, id: \.date) { element in
             BarMark(
                x: .value("Day", element.date, unit: chartUnit),
                y: .value("Total Sleep", element.duration)
             )
             .cornerRadius(5)
         }
    }
}

#Preview {
    SingleItemPreview<Child> { child in
        SleepChartView(child: child, period: .oneDay)
    }
    .modelContainer(PreviewData.container)
    .environmentObject(Trackr())
}
