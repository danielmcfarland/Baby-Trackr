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
            ExtractedView()
            
            ExtractedView()
            
            ExtractedView()
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
    var body: some View {
        HStack {
            ZStack {
                RoundedRectangle(cornerRadius: 10.0)
                    .foregroundStyle(Gradient(colors: [
                        Color.accent.opacity(0.7),
                        Color.accent.opacity(0.9),
                    ]))
                    .frame(width: 40, height: 40)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .strokeBorder(.white, lineWidth: 1)
                            .strokeBorder(.accent.opacity(0.5), lineWidth: 1)
                            .opacity(0.3)
                    )
                
                Image(systemName: "scalemass.fill")
            }
            
            Text("Weight")
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
            
            Spacer()
        }
        .padding()
        .background(Gradient(colors: [
            Color.accent.opacity(0.5),
            Color.accent.opacity(0.7),
        ]))
        .background(.white)
        .cornerRadius(25)
        .overlay(
            RoundedRectangle(cornerRadius: 25)
                .strokeBorder(.accent, lineWidth: 1)
                .opacity(/*@START_MENU_TOKEN@*/0.8/*@END_MENU_TOKEN@*/)
        )
        .padding(.horizontal)
        .padding(.bottom)
    }
}
