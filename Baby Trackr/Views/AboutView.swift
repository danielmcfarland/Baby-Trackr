//
//  AboutView.swift
//  Baby Trackr
//
//  Created by Daniel McFarland on 20/01/2024.
//

import SwiftUI

struct AboutView: View {
    var body: some View {
        List() {
            VStack(alignment: .leading) {
                HStack(alignment: .center) {
                    IconView(size: .small, icon: "b.circle.fill", shadow: false)
                    
                    Text("Baby Trackr")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                }
                .padding(.bottom, 5)
                
                Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
                    .padding(.bottom, 2)
                
                Text("Version 1.0")
                    .foregroundStyle(Color.gray)
                    .fontWeight(.semibold)
            }
            .padding(.bottom)
            .listRowInsets(EdgeInsets.init(top: 0, leading: 0, bottom: 0, trailing: 0))
            .listRowBackground(Color.clear)
            
            VStack {
                Text("Your feedback and suggestions are appreciated! Tap \"Feedback and Suggestions\" on the Settings page to send a message.")
            }
            .padding(.vertical)
            .listRowBackground(Color.clear)
            .listRowInsets(EdgeInsets.init(top: 0, leading: 0, bottom: 0, trailing: 0))
            
            VStack(alignment: .leading) {
                Text("Acknowledgements")
                    .fontWeight(.semibold)
                
                Text("Baby Trackr does not collect your personal data. All data synced with iCloud is private and only used to allow you to access your data on your devices.")
            }
            .padding(.vertical)
            .listRowBackground(Color.clear)
            .listRowInsets(EdgeInsets.init(top: 0, leading: 0, bottom: 0, trailing: 0))
        }
    }
}

#Preview {
    AboutView()
}
