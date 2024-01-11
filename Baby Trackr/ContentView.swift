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
        NavigationSplitView {
            List {
                ForEach(children) { item in
                    NavigationLink {
                        Text(item.name)
                    } label: {
                        Text(item.name)
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
        } detail: {
            Text("Select an item")
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
