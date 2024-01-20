//
//  MenuView.swift
//  Baby Trackr
//
//  Created by Daniel McFarland on 20/01/2024.
//

import SwiftUI

struct MenuView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            List {
                VStack {
                    HStack {
                        Spacer()
                        IconView(size: .larger, icon: "b.circle.fill", shadow: false)
                        Spacer()
                    }
                    .padding(.top, 10)
                    
                    Text("Baby Trackr")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("Version 1.0")
                        .foregroundStyle(Color.gray)
                        .font(.title3)
                        .fontWeight(.semibold)
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
