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
                                .font(.system(.footnote, design: .rounded, weight: .semibold))
                            //                                .foregroundStyle(.accent)
                            
                        } label: {                        Label("Weight", systemImage: "scalemass.fill")
                                .font(.system(.body, design: .rounded, weight: .semibold))
                            //                                .textCase(.uppercase)
                        }
                        
                        HStack {
                            Text("2134kg")
                                .font(.system(.title, design: .rounded, weight: .semibold))
                            
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
                                .font(.system(.footnote, design: .rounded, weight: .semibold))
                            
                        } label: {                        Label("Feed", systemImage: "waterbottle.fill")
                                .font(.system(.body, design: .rounded, weight: .semibold))
                            
                        }
                        
                        HStack {
                            Text("150ml")
                                .font(.system(.title, design: .rounded, weight: .semibold))
                            
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
