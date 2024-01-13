//
//  MeasurementView.swift
//  Baby Trackr
//
//  Created by Daniel McFarland on 13/01/2024.
//

import SwiftUI

struct MeasurementView: View {
    var measurement: Measurement

    var body: some View {
        List {
            Section(header: Text("Measurement Details")
            ) {
                VStack(alignment: .leading) {
                    Text(measurement.typeValue)
                        .foregroundStyle(Color.gray)
                        .font(.footnote)
                    Text("\(String(format: "%g", measurement.value)) \(measurement.type.getSymbol())")
                }
                VStack(alignment: .leading) {
                    Text("Date")
                        .foregroundStyle(Color.gray)
                        .font(.footnote)
                    Text(measurement.createdAt, format: Date.FormatStyle(date: .abbreviated, time: .standard))
                }
            }
        }
        .navigationTitle("Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}


#Preview {
    MeasurementView(measurement: Measurement(type: .height, value: 100, createdAt: Date()))
}
