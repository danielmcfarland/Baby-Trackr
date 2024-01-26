//
//  ChangeDetailView.swift
//  Baby Trackr
//
//  Created by Daniel McFarland on 24/01/2024.
//

import SwiftUI
import SwiftData

struct ChangeDetailView: View {
    @Query var changeQuery: [Change]
    @State var change: Change
    @State private var showDeletePrompt = false
    @State private var showEditChangeSheet = false
    @EnvironmentObject var trackr: Trackr
    @Environment(\.modelContext) private var modelContext
    @Environment(\.presentationMode) private var presentationMode
    
    var body: some View {
        List {
            Section(header: Text("Change Details")
            ) {
                VStack(alignment: .leading) {
                    Text("Date")
                        .foregroundStyle(Color.gray)
                        .font(.footnote)
                    Text(change.createdAt, format: Date.FormatStyle(date: .abbreviated, time: .shortened))
                }
                
                VStack(alignment: .leading) {
                    Text("Type")
                        .foregroundStyle(Color.gray)
                        .font(.footnote)
                    Text(change.type.rawValue)
                }
            }
        }
        .navigationTitle("Details")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    showEditChangeSheet.toggle()
                }, label: {
                    Text("Edit")
                })
            }
            ToolbarItem(placement: .bottomBar) {
                Button("Delete", role: .destructive, action: promptDelete)
            }
        }
        .sheet(isPresented: $showEditChangeSheet) {
            NavigationStack {
                if let child = change.child {
                    ChangeEntryView(change: change, child: child, in: modelContext.container)
                        .interactiveDismissDisabled()
                }
            }
        }

        .onChange(of: changeQuery) {
            if changeQuery.count > 0 {
                self.change = changeQuery.first!
            }
        }
        .confirmationDialog("Delete Change", isPresented: $showDeletePrompt) {
            Button("Delete", role: .destructive, action: {
                modelContext.delete(change)
                self.presentationMode.wrappedValue.dismiss()
            })
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Are you sure you want to delete this change?")
        }
    }
    
    func promptDelete() -> Void {
        self.showDeletePrompt = true
    }
}

#Preview {
    ChangeDetailView(change: Change(type: .dry))
}
