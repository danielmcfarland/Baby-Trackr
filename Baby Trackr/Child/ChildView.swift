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
            ExtractedView(title: "Weight", icon: "lines.measurement.vertical")
            
            ExtractedView(title: "Feed", icon: "waterbottle.fill")
            
            ExtractedView(title: "Sleep", icon: "moon.stars.fill")
            
            ExtractedView(title: "Change", icon: "arrow.triangle.2.circlepath")
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

struct ExtractedView: View {
    var title: String
    var icon: String
    
    var body: some View {
        HStack {
            ZStack {
                RoundedRectangle(cornerRadius: 10.0)
                    .foregroundStyle(Gradient(colors: [
                        Color.indigo.opacity(0.7),
                        Color.indigo.opacity(0.9),
                    ]))
                    .frame(width: 40, height: 40)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .strokeBorder(.white, lineWidth: 1)
                            .strokeBorder(.accent.opacity(0.5), lineWidth: 1)
                            .opacity(0.3)
                    )
                    .shadow(color: .indigo.opacity(0.4), radius: 20, x: 0, y: 0)
                
                Image(systemName: icon)
                    .foregroundStyle(.white)
            }
            
            Text(title)
                .foregroundStyle(Color("PurpleText"))
                .fontWeight(.semibold)
            
            Spacer()
        }
        .padding()
        .background(Gradient(colors: [
            Color.indigo.opacity(0.5),
            Color.indigo.opacity(0.7),
        ]))
        .cornerRadius(25)
        .overlay(
            RoundedRectangle(cornerRadius: 25)
                .strokeBorder(.indigo, lineWidth: 1)
                .opacity(/*@START_MENU_TOKEN@*/0.8/*@END_MENU_TOKEN@*/)
        )
        .shadow(color: .indigo.opacity(0.4), radius: 20, x: 0, y: 0)
        .padding(.horizontal)
        .padding(.bottom)
    }
}
