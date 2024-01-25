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
    var placeholderFeeds: [Sleep] = []
    
    @Query private var sleeps: [Sleep]
    
    init(child: Child, period: ChartPeriod) {
        let id = child.persistentModelID
        let periodDate: Date = period.periodDate
        
        self._sleeps = Query(filter: #Predicate<Sleep> { sleep in
            sleep.child?.persistentModelID == id &&
            sleep.createdAt > periodDate &&
            !sleep.trackrRunning
        })
        
        self.child = child
        self.period = period
    }
    
    var chartSleeps: [ChartSleep] {
        return Dictionary(grouping: sleeps, by: { sleep in
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
    SleepChartView(child: Child(name: "", dob: Date.distantPast, gender: ""), period: .sevenDays)
}
