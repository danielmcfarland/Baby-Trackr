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
    @State var value: Float? = nil
    @State var canSave: Bool = false
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
                        TextField("", value: $value, format: .number)
                            .keyboardType(.decimalPad)
                            .focused($focusedField, equals: .measurement)
                            .multilineTextAlignment(.trailing)
                            .onChange(of: value) {
                                canSave = false
                                guard let value = value else {
                                    return
                                }
                                
                                if value == 0 {
                                    return
                                }
                                
                                canSave = true
                            }
                    } label: {
                        Text(measurement.type.getSymbol())
                            .foregroundStyle(Color.gray)
                    }
                }
            }
            .navigationTitle(measurement.type.rawValue)
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
                    .disabled(!canSave)
                }
            }
            .onAppear {
                focusedField = .measurement
            }
        }
    }
    
    func save() -> Void {
        withAnimation {
            guard let value = value else {
                return
            }
            measurement.value = value
            modelContext.insert(measurement)
            child.measurements?.append(measurement)
            dismiss()
        }
    }
}

#Preview {
    AddMeasurementView(measurement: Measurement(type: .weight, value: 0, createdAt: Date()), child: Child(name: "Name", dob: Date(), gender: ""))
}
