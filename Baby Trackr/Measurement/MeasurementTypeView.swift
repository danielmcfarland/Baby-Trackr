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
    @Query private var measurements: [Measurement]

    
    init(type: ChildMeasurementType) {
        let id = type.child.persistentModelID
        let measurementType = type.measurementType.rawValue
        
        self._measurements = Query(filter: #Predicate<Measurement> { measurement in
            measurement.child?.persistentModelID == id
            &&
            measurement.typeValue == measurementType
        }, sort: \.createdAt)
        
        self.type = type
    }
    
    var body: some View {
        VStack {
            Picker("Measurement Period", selection: $measurementPeriod) {
                Text("D").tag(0)
                Text("W").tag(1)
                Text("M").tag(2)
                Text("Y").tag(3)
            }
            .pickerStyle(.segmented)
            .padding(.bottom, 10)
            .padding(.horizontal)
            
            ScrollView {
                Text("\(type.measurementType.rawValue) Measurements: \(measurements.count)")
                Text("\(type.child.name)")
                Text("All Child Measurements \(type.child.measurements?.count ?? 0)")
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
        .navigationTitle("\(type.measurementType.rawValue)")
        .navigationBarTitleDisplayMode(.large)
    }
}

#Preview {
    NavigationView {
        MeasurementTypeView(type: ChildMeasurementType(child: Child(name: "Name", dob: Date(), gender: ""), measurementType: .height))
    }
}
