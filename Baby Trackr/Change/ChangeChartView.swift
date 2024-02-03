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
    
    @Query private var changes: [Change]
    
    init(child: Child, period: ChartPeriod) {
        let id = child.persistentModelID
        let periodDate: Date = period.startDate
        
        self._changes = Query(filter: #Predicate<Change> { change in
            change.child?.persistentModelID == id &&
            change.createdAt > periodDate
        })
        
        self.child = child
        self.period = period
    }
    
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
    
    var chartChanges: [ChartChange] {
        return Dictionary(grouping: changes, by: { change in
            change.type
        }).map { type, changes in
            return ChartChange(value: changes.count, type: type)
        }.sorted {
            $0.type.rawValue < $1.type.rawValue
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Changes")
                .foregroundStyle(Color.gray)
                .font(.footnote)
                .fontWeight(.semibold)
            Text("\(scrollChartRange)")
                .fontWeight(.semibold)
                .padding(.bottom, 10)
            Chart(chartChanges, id: \.type) { change in
                SectorMark(
                    angle: .value("Duration", change.value),
                    innerRadius: .ratio(0.618),
                    angularInset: 1.5
                )
                .cornerRadius(5)
                .foregroundStyle(by: .value("Side", change.type.rawValue))
            }
            .chartXAxis(.hidden)
            .padding()
            .padding(.bottom, 0)
            .frame(height: 250)
            .animation(.default, value: chartChanges)
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
