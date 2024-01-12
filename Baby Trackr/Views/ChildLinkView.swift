//
//  ChildLinkView.swift
//  Baby Trackr
//
//  Created by Daniel McFarland on 12/01/2024.
//

import SwiftUI

struct ChildLinkView: View {
    var child: Child
    
    var body: some View {
        NavigationLink(value: child) {
            TitleCardView(title: child.name, icon: child.initialSymbol)
        }
    }
}

#Preview {
    ChildLinkView(child: Child(name: "Test Child", dob: Date(), gender: ""))
}
