//
//  FeedListView.swift
//  Baby Trackr
//
//  Created by Daniel McFarland on 17/01/2024.
//

import SwiftUI
import SwiftData

struct FeedListView: View {
    var child: Child

    @State private var showAddFeedSheet = false
    
    @Query private var feeds: [Feed]
    
    init(child: Child) {
        let id = child.persistentModelID
        
        self._feeds = Query(filter: #Predicate<Feed> { feed in
            feed.child?.persistentModelID == id
        }, sort: \.createdAt)
        
        self.child = child
    }
    
    var body: some View {
        List {
            ForEach(feeds) { feed in
                Text("\(feed.createdAt)")
            }
        }
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
            AddFeedView(feed: Feed(type: FeedType.bottle), child: child)
        }
        .navigationTitle("Feeds")
        .navigationBarTitleDisplayMode(.large)
    }
}

#Preview {
    FeedListView(child: Child(name: "Name", dob: Date(), gender: ""))
}
