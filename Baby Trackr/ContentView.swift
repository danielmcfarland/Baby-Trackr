//
//  ContentView.swift
//  Baby Trackr
//
//  Created by Daniel McFarland on 10/01/2024.
//

import SwiftUI
import SwiftData

struct ChildRecordType: Hashable {
    var child: Child
    var recordType: RecordType
}

struct ChildMeasurementType: Hashable {
    var child: Child
    var measurementType: MeasurementType
}

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var children: [Child]
    @State private var showAddChildView = false
    @State private var showMenuView = false
    @State private var path = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $path) {
            ScrollView {
                ForEach(children) { child in
                    ChildLinkView(child: child)
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: showAbout) {
                        Label("About", systemImage: "gearshape.fill")
                    }
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
            .sheet(isPresented: $showMenuView) {
                MenuView()
            }
            .navigationDestination(for: Child.self) { child in
                ChildView(child: child)
            }
            .navigationDestination(for: ChildRecordType.self) { recordType in
                RecordTypeView(type: recordType)
            }
            .navigationDestination(for: ChildMeasurementType.self) { measurementType in
                MeasurementTypeView(type: measurementType)
            }
            .navigationDestination(for: Measurement.self) { measurement in
                MeasurementView(measurement: measurement)
            }
            .navigationDestination(for: Feed.self) { feed in
                FeedDetailView(feed: feed)
            }
            .navigationDestination(for: Sleep.self) { sleep in
                SleepDetailView(sleep: sleep)
            }
            .navigationDestination(for: Change.self) { change in
                ChangeDetailView(change: change)
            }
            .navigationTitle("Baby Trackr")
            .navigationBarTitleDisplayMode(.large)
        }
    }
    
    private func addItem() {
        showAddChildView.toggle()
    }

    private func showAbout() {
        showMenuView.toggle()
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
        .modelContainer(PreviewData.container)
        .environmentObject(Trackr())
}
