//
//  ContentView.swift
//  Baby Trackr
//
//  Created by Daniel McFarland on 10/01/2024.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var children: [Child]
    @State private var showAddChildView = false

    var body: some View {
        NavigationStack {
            List {
                ForEach(children) { child in
                    NavigationLink(value: child) {
                        Text(child.name)
//                            .font(.system(.title2, design: .rounded, weight: .semibold))
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $showAddChildView) {
                AddChildView()
            }
            .navigationDestination(for: Child.self) { child in
                ChildView(child: child)
            }
            .navigationTitle("Baby Trackr")
            .navigationBarTitleDisplayMode(.large)
        }
    }

    private func addItem() {
        showAddChildView.toggle()

    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(children[index])
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Child.self, inMemory: true)
}
