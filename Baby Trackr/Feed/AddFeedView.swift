//
//  AddFeedView.swift
//  Baby Trackr
//
//  Created by Daniel McFarland on 17/01/2024.
//

import SwiftUI

struct AddFeedView: View {
    enum FocusedField {
        case measurement
    }
    
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) var dismiss
    @State var feed: Feed
    @State var value: Float? = nil
    @State var canSave: Bool = true
    @FocusState private var focusedField: FocusedField?
    var child: Child
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    DatePicker(selection: $feed.createdAt, in: ...Date(), displayedComponents: .date, label: {
                        Text("Date")
                            .foregroundStyle(Color.gray)
                    })
                    
                    DatePicker(selection: $feed.createdAt, in: ...Date(), displayedComponents: .hourAndMinute, label: {
                        Text("Time")
                            .foregroundStyle(Color.gray)
                    })
                    
                    Picker("Type", selection: $feed.typeValue) {
                        ForEach(FeedType.allCases) { feed in
                            Text(feed.rawValue).tag(feed.rawValue)
                        }
                    }
                    .foregroundStyle(Color.gray)
                    
                }
            }
            .navigationTitle("Feed")
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
            modelContext.insert(feed)
            child.feeds?.append(feed)
            dismiss()
        }
    }
}

#Preview {
    AddFeedView(feed: Feed(type: FeedType.bottle), child: Child(name: "", dob: Date(), gender: ""))
}
