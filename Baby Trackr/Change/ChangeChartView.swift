//
//  ChangeChartView.swift
//  Baby Trackr
//
//  Created by Daniel McFarland on 24/01/2024.
//

import SwiftUI
import SwiftData
import Charts

struct ChangeChartView: View {
    var child: Child
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
    
    @Query private var changes: [Change]
    var chartRange: Int
    
    init(child: Child, period: ChartPeriod) {
        let id = child.persistentModelID
        let periodDate: Date = period.startDate
        
        self._changes = Query(filter: #Predicate<Change> { change in
            change.child?.persistentModelID == id
        })
        
        self.child = child
        self.period = period
        self.chartRange = period.numberOfDays * 24 * 60 * 60
    }
    
    var chartChanges: [ChartChange] {
        var chartChanges: [ChartChange] = []
        let startOfPeriodSleep = ChartChange(date: period.startDate, value: 0, type: .dry)
        chartChanges.append(startOfPeriodSleep)

        let endOfTodaySleep = ChartChange(date: Calendar.current.startOfDay(for: Date.now), value: 0, type: .dry)
        chartChanges.append(endOfTodaySleep)
        
        ChangeType.allCases.forEach { changeType in
            let items = getChangeType(data: changes, changeType: changeType)
            chartChanges.append(contentsOf: items)
        }
        
        return chartChanges
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .center) {
                IconView(size: .small, icon: "arrow.triangle.2.circlepath")
                VStack(alignment: .leading, spacing: 0) {
                    Text("Change")
                        .foregroundStyle(Color.gray)
                        .font(.footnote)
                        .fontWeight(.semibold)
                    Text("\(scrollChartRange)")
                        .fontWeight(.semibold)
                }
            }
            .padding(.bottom, 10)
            Chart(chartChanges, id: \.date) { element in
                BarMark(
                    x: .value("Day", element.date, unit: .day),
                    y: .value("Total", element.value)
                )
                .foregroundStyle(by: .value("Change Type", element.type.rawValue))
                .position(by: .value("Change Type", element.type.rawValue))
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
//            Chart(chartChanges, id: \.type) { change in
//                SectorMark(
//                    angle: .value("Duration", change.value),
//                    innerRadius: .ratio(0.618),
//                    angularInset: 1.5
//                )
//                .cornerRadius(5)
//                .foregroundStyle(by: .value("Side", change.type.rawValue))
//            }
//            .chartXAxis(.hidden)
//            .padding()
//            .padding(.bottom, 0)
//            .frame(height: 250)
//            .animation(.default, value: chartChanges)
        }
    }
    
    func getChangeType(data: [Change], changeType: ChangeType) -> [ChartChange] {
        
        let changes = data.filter { change in
            return change.type == changeType
        }
        
        return Dictionary(grouping: changes, by: { change in
            let components = [
                Calendar.Component.day,
                Calendar.Component.month,
                Calendar.Component.year,
            ]
            return Calendar.current.dateComponents(Set(components), from: change.createdAt)
        }).map { dateComponents, changes in
            
            let components = DateComponents(year: dateComponents.year, month: dateComponents.month, day: dateComponents.day)
            
            let date = Calendar.current.date(from: components)!
            
            return ChartChange(date: date, value: changes.count, type: changeType)
        }
    }
}

#Preview {
    SingleItemPreview<Child> { child in
        NavigationStack {
            ChangeChartView(child: child, period: .sevenDays)
        }
    }
    .modelContainer(PreviewData.container)
    .environmentObject(Trackr())
}
