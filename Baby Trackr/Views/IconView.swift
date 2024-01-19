//
//  IconView.swift
//  Baby Trackr
//
//  Created by Daniel McFarland on 12/01/2024.
//

import SwiftUI

struct IconView: View {
    
    enum IconSize: Double {
        case small = 41.75
        case large = 83.5
        case icon = 1024.0
        
        func getCornerRadius() -> CGFloat {
            self.rawValue / IconSize.large.rawValue * 18.5
        }
        
        func getFontSize() -> CGFloat {
            self.rawValue / 2
        }
        
        func getLineWidth() -> CGFloat {
            self.rawValue / IconSize.small.rawValue * 1
        }
        
        func getShadowRdius() -> CGFloat {
            self.rawValue / IconSize.large.rawValue * 20
        }
    }
    
    var size: IconSize = .small
    var icon: String = ""
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: size.getCornerRadius())
                .foregroundStyle(Gradient(colors: [
                    Color.indigo.opacity(0.7),
                    Color.indigo.opacity(0.9),
                ]))
                .frame(width: CGFloat(size.rawValue), height: CGFloat(size.rawValue))
                .overlay(
                    RoundedRectangle(cornerRadius: size.getCornerRadius())
                        .strokeBorder(.white, lineWidth: size.getLineWidth())
                        .strokeBorder(.accent.opacity(0.5), lineWidth: size.getLineWidth())
                        .opacity(0.3)
                )
                .shadow(color: .indigo.opacity(0.4), radius: size.getShadowRdius(), x: 0, y: 0)
            
            Image(systemName: icon)
                .foregroundStyle(.white)
                .font(.system(size: size.getFontSize()))
        }
    }
}

#Preview {
    IconView(size: .large, icon: "b.circle.fill")
}
