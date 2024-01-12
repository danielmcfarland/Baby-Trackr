//
//  ChildView.swift
//  Baby Trackr
//
//  Created by Daniel McFarland on 11/01/2024.
//

import SwiftUI

struct ChildView: View {
    var child: Child
    
    var body: some View {
        ScrollView {
            TitleCardView(title: "Weight", icon: "lines.measurement.vertical")
            
            TitleCardView(title: "Feed", icon: "waterbottle.fill")
            
            TitleCardView(title: "Sleep", icon: "moon.stars.fill")
            
            TitleCardView(title: "Change", icon: "arrow.triangle.2.circlepath")
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
