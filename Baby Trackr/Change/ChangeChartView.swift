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
        let periodDate: Date = period.periodDate
        
        self._changes = Query(filter: #Predicate<Change> { change in
            change.child?.persistentModelID == id &&
            change.createdAt > periodDate
        })
        
        self.child = child
        self.period = period
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

#Preview {
    ChangeChartView(child: Child(name: "", dob: Date.distantPast, gender: ""), period: .sevenDays)
}
