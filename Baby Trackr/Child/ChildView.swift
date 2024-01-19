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
//            NavigationLink(value: ChildRecordType(child: child, recordType:  .measurement)) {
//                TitleCardView(title: "Measurements", icon: "lines.measurement.vertical")
//            }
            
            NavigationLink(value: ChildRecordType(child: child, recordType:  .feed)) {
                TitleCardView(title: "Feed", icon: "waterbottle.fill")
            }
            
            NavigationLink(value: ChildRecordType(child: child, recordType:  .sleep)) {
                TitleCardView(title: "Sleep", icon: "moon.stars.fill")
            }
            
            NavigationLink(value: ChildRecordType(child: child, recordType:  .change)) {
                TitleCardView(title: "Change", icon: "arrow.triangle.2.circlepath")
            }
            
//            NavigationLink(value: ChildRecordType(child: child, recordType:  .note)) {
//                TitleCardView(title: "Notes", icon: "list.clipboard.fill")
//            }
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
