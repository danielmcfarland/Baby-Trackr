//
//  SaveView.swift
//  Baby Trackr
//
//  Created by Daniel McFarland on 17/01/2024.
//

import Foundation
import SwiftUI

extension View {
    func snapshot() -> UIImage {
        let controller = UIHostingController(rootView: self)
        let view = controller.view

        let targetSize = controller.view.intrinsicContentSize
        view?.bounds = CGRect(origin: .zero, size: targetSize)
        view?.backgroundColor = .clear

        let renderer = UIGraphicsImageRenderer(size: targetSize)

        return renderer.image { _ in
            view?.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
        }
    }
}

struct SaveIconView: View {
    var iconView: some View {
        IconView(size: .icon, icon: "b.circle.fill")
    }

    var body: some View {
        ZStack {
            iconView

            Button("Save to image") {
                let image = iconView.snapshot()

                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            }
        }
    }
}

#Preview {
    SaveIconView()
}
