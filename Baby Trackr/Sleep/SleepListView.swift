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
    
    @State private var showAddSleepSheet = false
    
    @Query private var sleeps: [Sleep]
    
    
    init(child: Child) {
        let id = child.persistentModelID
        
        self._sleeps = Query(filter: #Predicate<Sleep> { sleep in
            sleep.child?.persistentModelID == id
        }, sort: \.startTime)
        
        self.child = child
    }
    
    var body: some View {
        List {
            ForEach(sleeps) { sleep in
                NavigationLink(value: sleep) {
                    Text("Sleep Duration: \(sleep.duration)")
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
            CurrentSleepView(child: child, sleep: Sleep())
        }
        .navigationTitle("Sleeping")
        .navigationBarTitleDisplayMode(.large)
    }
}

#Preview {
    SleepListView(child: Child(name: "Name", dob: Date(), gender: ""))
}
