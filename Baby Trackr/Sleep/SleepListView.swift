//
//  SleepListView.swift
//  Baby Trackr
//
//  Created by Daniel McFarland on 14/01/2024.
//

import SwiftUI
import SwiftData

struct SleepListView: View {
    var child: Child
    @Environment(\.modelContext) private var modelContext
    
    @State var period: ChartPeriod = ChartPeriod.sevenDays
    
    @State private var showAddSleepSheet = false
    
    @Query private var sleeps: [Sleep]
    
    init(child: Child) {
        let id = child.persistentModelID
        
        self._sleeps = Query(filter: #Predicate<Sleep> { sleep in
            sleep.child?.persistentModelID == id
        }, sort: \.createdAt, order: .reverse)
        
        self.child = child
    }
    
    var body: some View {
        List {
            SleepChartView(child: child, period: period)
                .listRowBackground(Color.clear)
                .listRowSpacing(0)
                .listRowSeparator(.hidden)
                .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                .frame(height: 250)
            
            Section {
                ForEach(sleeps) { sleep in
                    NavigationLink(value: sleep) {
                        HStack {
                            if sleep.trackrRunning {
                                HStack {
                                    Image(systemName: "record.circle")
                                        .foregroundStyle(Color.red)
                                    Text("In Progress")
                                }
                            } else {
                                Text(sleep.humanReadableDuration)
                            }
                            Spacer()
                            Text(sleep.createdAt, format: Date.FormatStyle(date: .abbreviated, time: .shortened))
                                .foregroundStyle(Color.gray)
                        }
                    }
                    
                }
            }
        }
        .toolbar{
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    showAddSleepSheet.toggle()
                }, label: {
                    Image(systemName: "plus")
                })
            }
        }
        .sheet(isPresented: $showAddSleepSheet) {
            NavigationStack {
                SleepEntryView(sleep: nil, child: child, in: modelContext.container)
                    .interactiveDismissDisabled()
            }
        }
        .navigationTitle("Sleep")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    SingleItemPreview<Child> { child in
        SleepListView(child: child)
    }
    .modelContainer(PreviewData.container)
    .environmentObject(Trackr())
}
