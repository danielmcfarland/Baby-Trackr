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
        List {
            Section {
                NavigationLink(value: child) {
                    VStack {
                        LabeledContent {
                            Text("8 Jan")
                                .font(.system(.footnote, design: .default, weight: .regular))
                        } label: {                        Label("Weight", systemImage: "scalemass.fill")
                                .font(.system(.body, design: .default, weight: .regular))
                        }
                        
                        HStack {
                            Text("2134kg")
                                .font(.system(.title, design: .default, weight: .regular))
                            Spacer()
                        }
                    }
                }
            }
            
            Section {
                NavigationLink(value: child) {
                    VStack {
                        LabeledContent {
                            Text("8 Jan")
                                .font(.system(.footnote, design: .default, weight: .regular))
                        } label: {                        Label("Feed", systemImage: "waterbottle.fill")
                                .font(.system(.body, design: .default, weight: .regular))
                            
                        }
                        
                        HStack {
                            Text("150ml")
                                .font(.system(.title, design: .default, weight: .regular))
                            Spacer()
                        }
                    }
                }
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
