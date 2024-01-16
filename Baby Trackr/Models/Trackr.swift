//
//  Trackr.swift
//  Baby Trackr
//
//  Created by Daniel McFarland on 16/01/2024.
//

import Foundation
import Combine

class Trackr: ObservableObject {
    @Published var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
}
