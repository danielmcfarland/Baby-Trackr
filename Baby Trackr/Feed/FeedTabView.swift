//
//  FeedTabView.swift
//  Baby Trackr
//
//  Created by Daniel McFarland on 22/01/2024.
//

import SwiftUI

struct FeedTabView: View {
    var child: Child
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
        .navigationBarTitleDisplayMode(.large)
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
                AddFeedView(feed: Feed(type: .bottle), child: child)
            }
        }
    }
}

#Preview {
    FeedTabView(child: Child(name: "Name", dob: Date(), gender: ""))
}
