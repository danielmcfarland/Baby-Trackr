//
//  AboutView.swift
//  Baby Trackr
//
//  Created by Daniel McFarland on 20/01/2024.
//

import SwiftUI

struct AboutView: View {
    let appVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String?
    let appBuild = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String?
    
    var body: some View {
        List() {
            VStack(alignment: .leading) {
                HStack(alignment: .center) {
                    IconView(size: .small, icon: "b.circle.fill", shadow: false)
                    
                    Text("Baby Trackr")
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                }
                .padding(.bottom, 5)
                
                Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
                    .padding(.bottom, 2)
                
                if let appVersion = appVersion, let appBuild = appBuild {
                    Text("Version \(appVersion) (\(appBuild))")
                        .foregroundStyle(Color.gray)
                        .fontWeight(.medium)
                } else if let appVersion = appVersion {
                    Text("Version \(appVersion)")
                        .foregroundStyle(Color.gray)
                        .fontWeight(.medium)
                }
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
