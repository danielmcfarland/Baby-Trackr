//
//  MenuView.swift
//  Baby Trackr
//
//  Created by Daniel McFarland on 20/01/2024.
//

import SwiftUI

struct MenuView: View {
    @Environment(\.dismiss) var dismiss
    let appVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String?
    let appBuild = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String?
    
    var body: some View {
        NavigationStack {
            List {
                VStack {
                    HStack {
                        Spacer()
                        IconView(size: .larger, icon: "b.circle.fill", shadow: false)
                        Spacer()
                    }
                    
                    Text("Baby Trackr")
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                    
                    if let appVersion = appVersion, let appBuild = appBuild {
                        Text("Version \(appVersion) (\(appBuild))")
                            .foregroundStyle(Color.gray)
                            .font(.title3)
                            .fontWeight(.medium)
                    } else if let appVersion = appVersion {
                        Text("Version \(appVersion)")
                            .foregroundStyle(Color.gray)
                            .font(.title3)
                            .fontWeight(.medium)
                    }
                }
                .listRowSeparator(.hidden)
                .listRowInsets(EdgeInsets.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                .listRowBackground(Color.clear)
                
                Section {
                    NavigationLink("About", destination: AboutView())
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
        
    }
}

#Preview {
    MenuView()
}
