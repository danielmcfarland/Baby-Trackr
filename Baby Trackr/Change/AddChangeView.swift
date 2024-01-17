//
//  AddChangeView.swift
//  Baby Trackr
//
//  Created by Daniel McFarland on 17/01/2024.
//

import SwiftUI

struct AddChangeView: View {
    
    enum FocusedField {
        case measurement
    }
    
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) var dismiss
    @State var change: Change
    @State var value: Float? = nil
    @State var canSave: Bool = true
    @FocusState private var focusedField: FocusedField?
    var child: Child
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    DatePicker(selection: $change.createdAt, in: ...Date(), displayedComponents: .date, label: {
                        Text("Date")
                            .foregroundStyle(Color.gray)
                    })
                    
                    DatePicker(selection: $change.createdAt, in: ...Date(), displayedComponents: .hourAndMinute, label: {
                        Text("Time")
                            .foregroundStyle(Color.gray)
                    })
                    
                    Picker("Type", selection: $change.typeValue) {
                        ForEach(ChangeType.allCases) { change in
                            Text(change.rawValue).tag(change.rawValue)
                        }
                    }
                    .foregroundStyle(Color.gray)
                    
                }
            }
            .navigationTitle("Change")
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
//            guard let value = value else {
//                return
//            }
//            measurement.value = value
            modelContext.insert(change)
            child.changes?.append(change)
            dismiss()
        }
    }
}

#Preview {
    AddChangeView(change: Change(type: ChangeType.wet), child: Child(name: "", dob: Date(), gender: ""))
}
