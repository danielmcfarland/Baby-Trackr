//
//  FeedTabView.swift
//  Baby Trackr
//
//  Created by Daniel McFarland on 22/01/2024.
//

import SwiftUI

struct FeedTabView: View {
    var child: Child
    @Environment(\.modelContext) private var modelContext
    @State private var showAddFeedSheet = false
    
    var body: some View {
        TabView {
            FeedListView(child: child, feedType: .breast)
                .tabItem {
                    Label("Breast", systemImage: "square.fill")
                }
            FeedListView(child: child, feedType: .bottle)
                .tabItem {
                    Label("Bottle", systemImage: "square.fill")
                }
        }
        .navigationTitle("Feed")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar{
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    showAddFeedSheet.toggle()
                }, label: {
                    Image(systemName: "plus")
                })
            }
        }
        .sheet(isPresented: $showAddFeedSheet) {
            NavigationStack {
                AddFeedView(feed: nil, child: child, in: modelContext.container)
            }
        }
    }
}

#Preview {
    FeedTabView(child: Child(name: "Name", dob: Date(), gender: ""))
}
