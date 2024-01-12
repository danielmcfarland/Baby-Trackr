//
//  TitleCardView.swift
//  Baby Trackr
//
//  Created by Daniel McFarland on 12/01/2024.
//

import SwiftUI

struct TitleCardView: View {
    var title: String
    var icon: String
    
    var body: some View {
        HStack {
            IconView(icon: icon)
            
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

#Preview {
    TitleCardView(title: "Measurement", icon: "lines.measurement.vertical")
}
