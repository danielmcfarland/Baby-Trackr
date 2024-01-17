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

    @State private var showAddChangeSheet = false
    
    @Query private var changes: [Change]
    
    init(child: Child) {
        let id = child.persistentModelID
        
        self._changes = Query(filter: #Predicate<Change> { change in
            change.child?.persistentModelID == id
        }, sort: \.createdAt)
        
        self.child = child
    }
    
    var body: some View {
        List {
            ForEach(changes) { change in
                Text("\(change.createdAt)")
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
            AddChangeView(change: Change(type: ChangeType.dry), child: child)
        }
        .navigationTitle("Changes")
        .navigationBarTitleDisplayMode(.large)
    }
}

#Preview {
    ChangeListView(child: Child(name: "Name", dob: Date(), gender: ""))
}
