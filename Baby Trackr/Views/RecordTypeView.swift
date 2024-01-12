//
//  RecordTypeView.swift
//  Baby Trackr
//
//  Created by Daniel McFarland on 12/01/2024.
//

import SwiftUI

struct RecordTypeView: View {
    var type: RecordType
    
    var body: some View {
        switch type {
        case .measurement:
            ChooseMeasurementTypeView()
        case .change:
            Text("change")
        case .feed:
            Text("feed")
        case .sleep:
            Text("sleep")
        case .note:
            Text("note")
        }
    }
}

#Preview {
    RecordTypeView(type: .feed)
}
