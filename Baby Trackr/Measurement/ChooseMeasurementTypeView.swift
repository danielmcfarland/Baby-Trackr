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
                TitleCardView(title: "Weight", icon: "scalemass.fill")
            }
            
            NavigationLink(value: ChildMeasurementType(child: child, measurementType: .height)) {
                TitleCardView(title: "Height", icon: "lines.measurement.vertical")
            }
        }
        .navigationTitle("Measurements")
        .navigationBarTitleDisplayMode(.large)
    }
}

#Preview {
    ChooseMeasurementTypeView(child: Child(name: "Name", dob: Date(), gender: ""))
}
