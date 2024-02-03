//
//  ChangeListView.swift
//  Baby Trackr
//
//  Created by Daniel McFarland on 17/01/2024.
//

import SwiftUI
import SwiftData

struct ChangeListView: View {
    var child: Child

    @Environment(\.modelContext) private var modelContext
    
    @State private var showAddChangeSheet = false
    
    @Query private var changes: [Change]
    
    @State var period: ChartPeriod = ChartPeriod.sevenDays
    
    init(child: Child) {
        let id = child.persistentModelID
        
        self._changes = Query(filter: #Predicate<Change> { change in
            change.child?.persistentModelID == id
        }, sort: \.createdAt, order: .reverse)
        
        self.child = child
    }
    
    var body: some View {
        List {            
            ChangeChartView(child: child, period: period)
                .listRowBackground(Color.clear)
                .listRowSpacing(0)
                .listRowSeparator(.hidden)
                .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                .frame(height: 250)
            
            Section {
                ForEach(changes) { change in
                    NavigationLink(value: change) {
                        HStack {
                            Text("\(change.type.rawValue)")
                            Spacer()
                            Text(change.createdAt, format: Date.FormatStyle(date: .abbreviated, time: .shortened))
                                .foregroundStyle(Color.gray)
                        }
                    }
                }
            }
        }
        .toolbar{
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    showAddChangeSheet.toggle()
                }, label: {
                    Image(systemName: "plus")
                })
            }
        }
        .sheet(isPresented: $showAddChangeSheet) {
            ChangeEntryView(change: nil, child: child, in: modelContext.container)
                .interactiveDismissDisabled()
        }
        .navigationTitle("Changes")
        .navigationBarTitleDisplayMode(.inline)
        .listStyle(DefaultListStyle())
    }
}

#Preview {
    SingleItemPreview<Child> { child in
        NavigationStack {
            ChangeListView(child: child)
        }
    }
    .modelContainer(PreviewData.container)
}
