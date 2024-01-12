//
//  ChooseMeasurementTypeView.swift
//  Baby Trackr
//
//  Created by Daniel McFarland on 12/01/2024.
//

import SwiftUI

struct ChooseMeasurementTypeView: View {
    var body: some View {
        ScrollView {
            NavigationLink(value: MeasurementType.weight) {
                TitleCardView(title: "Weight", icon: "scalemass.fill")
            }
            
            NavigationLink(value: MeasurementType.height) {
                TitleCardView(title: "Height", icon: "lines.measurement.vertical")
            }
        }
        .navigationTitle("Measurements")
        .navigationBarTitleDisplayMode(.large)
    }
}

#Preview {
    ChooseMeasurementTypeView()
}
