//
//  MeasurementTypeView.swift
//  Baby Trackr
//
//  Created by Daniel McFarland on 12/01/2024.
//

import SwiftUI

struct MeasurementTypeView: View {
    var type: MeasurementType
    
    @State var measurementPeriod: Int = 0
    @State private var showAddMeasurementView = false
    
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
            AddMeasurementView(measurement: Measurement(type: type, value: 0))
        }
        .navigationTitle(type.rawValue)
        .navigationBarTitleDisplayMode(.large)
    }
}

#Preview {
    NavigationView {
        MeasurementTypeView(type: .height)
    }
}
