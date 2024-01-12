//
//  ChildView.swift
//  Baby Trackr
//
//  Created by Daniel McFarland on 11/01/2024.
//

import SwiftUI

struct ChildView: View {
    @State var child: Child
    
    var body: some View {
        ScrollView {
            NavigationLink(value: RecordType.measurement) {
                TitleCardView(title: "Measurements", icon: "lines.measurement.vertical")
            }
            
            NavigationLink(value: RecordType.feed) {
                TitleCardView(title: "Feeding", icon: "waterbottle.fill")
            }
            
            NavigationLink(value: RecordType.sleep) {
                TitleCardView(title: "Sleeping", icon: "moon.stars.fill")
            }
            
            NavigationLink(value: RecordType.change) {
                TitleCardView(title: "Changes", icon: "arrow.triangle.2.circlepath")
            }
            
            NavigationLink(value: RecordType.note) {
                TitleCardView(title: "Notes", icon: "list.clipboard.fill")
            }
        }
        .navigationTitle(child.name)
        .navigationBarTitleDisplayMode(.large)
    }
}

#Preview {
    NavigationView {
        ChildView(child: Child(name: "Child Name", dob: Date(), gender: "male"))
    }
}
