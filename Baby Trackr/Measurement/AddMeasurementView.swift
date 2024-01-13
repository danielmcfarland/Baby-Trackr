//
//  AddMeasurementView.swift
//  Baby Trackr
//
//  Created by Daniel McFarland on 12/01/2024.
//

import SwiftUI

struct AddMeasurementView: View {
    
    enum FocusedField {
        case measurement
    }
    
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) var dismiss
    @State var measurement: Measurement
    @FocusState private var focusedField: FocusedField?
    var child: Child
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    
                    DatePicker(selection: $measurement.createdAt, in: ...Date(), displayedComponents: .date, label: {
                        Text("Date")
                            .foregroundStyle(Color.gray)
                    })
                    
                    DatePicker(selection: $measurement.createdAt, in: ...Date(), displayedComponents: .hourAndMinute, label: {
                        Text("Time")
                            .foregroundStyle(Color.gray)
                    })
                    
                    LabeledContent {
                        TextField("", value: $measurement.value, format: .number)
                            .keyboardType(.numberPad)
                            .focused($focusedField, equals: .measurement)
                            .multilineTextAlignment(.trailing)
                    } label: {
                        Text(measurement.type == MeasurementType.height ? "cm" : "g")
                            .foregroundStyle(Color.gray)
                    }
                }
            }
            .navigationTitle(measurement.type == MeasurementType.height ? "Height" : "Weight")
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
                        Text("Add")
                    }
                    .disabled(measurement.value <= 0)
                }
            }
            .onAppear {
                focusedField = .measurement
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
    AddMeasurementView(measurement: Measurement(type: .weight, value: 0, createdAt: Date()), child: Child(name: "Name", dob: Date(), gender: ""))
}
