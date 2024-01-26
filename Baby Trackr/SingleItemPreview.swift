//
//  SingleItemPreview.swift
//  Baby Trackr
//
//  Created by Daniel McFarland on 26/01/2024.
//

import Foundation
import SwiftData
import SwiftUI

struct SingleItemPreview<T: PersistentModel>: View {
    @Query var queryItems: [T] // get items of type T (ex. TodoItem)
    var renderView: (T) -> any View // closure function to render your view
    
    init(renderViewFunction: @escaping (T) -> any View) {
        self.renderView = renderViewFunction
    }
    var body: some View {
        AnyView(renderView(queryItems.first!)) // render your view with first item
    }
}
