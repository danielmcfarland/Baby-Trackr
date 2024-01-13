//
//  MeasurementTypeView.swift
//  Baby Trackr
//
//  Created by Daniel McFarland on 12/01/2024.
//

import SwiftUI
import SwiftData

struct MeasurementTypeView: View {
    var type: ChildMeasurementType
    
    @State var measurementPeriod: Int = 0
    @State private var showAddMeasurementView = false
    
//    @Query(filter: #Predicate<Measurement> { measurement in
//        measurement.child?.id == type.self.child.id
//    }) private var measurements: [Measurement] = []
    @Query private var measurements: [Measurement]
    
    var body: some View {
        VStack {
            Picker("Measurement Period", selection: $measurementPeriod) {
                Text("30 Days").tag(0)
                Text("All").tag(1)
            }
            .pickerStyle(.segmented)
            .padding(.bottom, 10)
            .padding(.horizontal)
            
            ScrollView {
                Text("\(measurements.count)")
                Text("\(type.child.name)")
                Text("\(type.child.measurements?.count ?? 0)")
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    showAddMeasurementView.toggle()
                }, label: {
                    Image(systemName: "plus")
                })
            }
        }
        .sheet(isPresented: $showAddMeasurementView) {
            AddMeasurementView(measurement: Measurement(type: type.measurementType, value: 0, createdAt: Date()), child: type.child)
        }
        .navigationTitle(type.measurementType.rawValue)
        .navigationBarTitleDisplayMode(.large)
    }
}

#Preview {
    NavigationView {
        MeasurementTypeView(type: ChildMeasurementType(child: Child(name: "Name", dob: Date(), gender: ""), measurementType: .height))
    }
}
