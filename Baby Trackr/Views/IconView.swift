//
//  IconView.swift
//  Baby Trackr
//
//  Created by Daniel McFarland on 12/01/2024.
//

import SwiftUI

struct IconView: View {
    
    enum IconSize: Int {
        case small = 40
        case large = 80
        case icon = 1024
    }
    
    var size: IconSize = .small
    var icon: String = ""
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: size == .icon ? 0 : 10)
                .foregroundStyle(Gradient(colors: [
                    Color.indigo.opacity(0.7),
                    Color.indigo.opacity(0.9),
                ]))
                .frame(width: CGFloat(integerLiteral: size.rawValue), height: CGFloat(integerLiteral: size.rawValue))
                .overlay(
                    RoundedRectangle(cornerRadius: size == .icon ? 0 : 10)
                        .strokeBorder(.white, lineWidth: size == .icon ? 0 : 1)
                        .strokeBorder(.accent.opacity(0.5), lineWidth: 1)
                        .opacity(0.3)
                )
                .shadow(color: .indigo.opacity(0.4), radius: size == .icon ? 0 : 20, x: 0, y: 0)
            
            Image(systemName: icon)
                .foregroundStyle(.white)
                .font(.system(size: CGFloat(integerLiteral: size.rawValue / 2)))
        }
    }
}

#Preview {
    IconView(size: .large, icon: "a.circle.fill")
}
