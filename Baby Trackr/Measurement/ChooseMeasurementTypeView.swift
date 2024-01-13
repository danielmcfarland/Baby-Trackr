//
//  ChooseMeasurementTypeView.swift
//  Baby Trackr
//
//  Created by Daniel McFarland on 12/01/2024.
//

import SwiftUI

struct ChooseMeasurementTypeView: View {
    var child: Child

    var body: some View {
        ScrollView {
            NavigationLink(value: ChildMeasurementType(child: child, measurementType: .weight)) {
                TitleCardView(title: MeasurementType.weight.rawValue, icon: "scalemass.fill")
            }
            
            NavigationLink(value: ChildMeasurementType(child: child, measurementType: .height)) {
                TitleCardView(title: MeasurementType.height.rawValue, icon: "lines.measurement.vertical")
            }
            
            NavigationLink(value: ChildMeasurementType(child: child, measurementType: .temperature)) {
                TitleCardView(title: MeasurementType.temperature.rawValue, icon: "medical.thermometer.fill")
            }
        }
        .navigationTitle("Measurements")
        .navigationBarTitleDisplayMode(.large)
    }
}

#Preview {
    ChooseMeasurementTypeView(child: Child(name: "Name", dob: Date(), gender: ""))
}
