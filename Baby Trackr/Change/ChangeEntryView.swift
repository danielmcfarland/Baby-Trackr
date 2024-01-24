//
//  AddChangeView.swift
//  Baby Trackr
//
//  Created by Daniel McFarland on 17/01/2024.
//

import SwiftUI
import SwiftData

struct ChangeEntryView: View {
    @Bindable private var child: Child
    @Bindable private var change: Change
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var trackr: Trackr
    @State private var currentDuration: Int = 0
    @State private var showCancelPrompt = false
    private var modelContext: ModelContext
    
    init(change: Change?, child: Child, in container: ModelContainer) {
        modelContext = ModelContext(container)
        if let change = change {
            modelContext.autosaveEnabled = false
            self.change = (modelContext.model(for: change.persistentModelID) as? Change)!
        } else {
            self.change = Change(type: .wet)
        }
        self.child = (modelContext.model(for: child.persistentModelID) as? Child)!
    }
    
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
                    Button(action: cancelChange) {
                        Text("Cancel")
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: save) {
                        Text("Save")
                    }
                    .disabled(!canSave)
                }
            }
            .confirmationDialog("Cancel Feed", isPresented: $showCancelPrompt) {
                Button("Yes", action: {
                    dismiss()
                })
                Button("No", role: .cancel) { }
            } message: {
                Text("Are you sure you want to cancel this feed without saving?")
            }
        }
    }
    
    private var canSave: Bool {
        return true
    }
    
    func cancelChange() -> Void {
        if modelContext.hasChanges {
            showCancelPrompt.toggle()
        } else {
            dismiss()
        }
    }
    
    func save() -> Void {
        withAnimation {
            if let _ = change.child {
                try? modelContext.save()
            } else {
                modelContext.insert(change)
                child.changes?.append(change)
            }
            dismiss()
        }
    }
}

#Preview {
    ChangeEntryView(change: Change(type: ChangeType.wet), child: Child(name: "", dob: Date(), gender: ""), in: PreviewData.container)
}
