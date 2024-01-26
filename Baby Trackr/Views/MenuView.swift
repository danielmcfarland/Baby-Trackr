//
//  MenuView.swift
//  Baby Trackr
//
//  Created by Daniel McFarland on 20/01/2024.
//

import SwiftUI
import StoreKit

struct MenuView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.requestReview) var requestReview
    
    let appVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String?
    let appBuild = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String?
    
    let emailAddress = "babytrackr@mcfarland.app"
    let emailBody = ""
    let emailSubject = "Feedback and Suggestions"
    
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
                    NavigationLink(destination: AboutView()) {
                        Label("About", systemImage: "signature")
                    }
                    
                    Link(destination: URL(string: "mailto:\(emailAddress)?subject=\(emailSubject.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? "")&body=\(emailBody.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? "")")!) {
                        Label {
                            Text("Feedback and Suggestions")
                                .foregroundStyle(Color.primary)
                        } icon: {
                            Image(systemName: "envelope")
                                .foregroundStyle(Color.accent)
                        }
                    }
                    
                    Button(action: {
                        requestReview()
                    }) {
                        Label {
                            Text("Leave a Review")
                                .foregroundStyle(Color.primary)
                        } icon: {
                            Image(systemName: "star")
                                .foregroundStyle(Color.accent)
                        }
                    }
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
