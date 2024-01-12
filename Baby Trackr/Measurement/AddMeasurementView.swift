//
//  AddMeasurementView.swift
//  Baby Trackr
//
//  Created by Daniel McFarland on 12/01/2024.
//

import SwiftUI

struct AddMeasurementView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) var dismiss
    @State var measurement: Measurement
    var child: Child
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Placeholder", value: $measurement.value, format: .number)
                        .keyboardType(.numberPad)
                }
            }
            .navigationTitle("Add Measurement")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        Text("Cancel")
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        save()
                    }) {
                        Text("Done")
                    }
                    .disabled(measurement.value == 0)
                }
            }
        }
    }
    
    func save() -> Void {
        withAnimation {
            modelContext.insert(measurement)
            child.measurements?.append(measurement)
            dismiss()
        }
    }
}

#Preview {
    AddMeasurementView(measurement: Measurement(type: .weight, value: 0), child: Child(name: "Name", dob: Date(), gender: ""))
}
