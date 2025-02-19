//
//  RecordTypeView.swift
//  Baby Trackr
//
//  Created by Daniel McFarland on 12/01/2024.
//

import SwiftUI

struct RecordTypeView: View {
    var type: ChildRecordType
    
    var body: some View {
        switch type.recordType {
        case .measurement:
            ChooseMeasurementTypeView(child: type.child)
        case .change:
            ChangeListView(child: type.child)
        case .feed:
            FeedTabView(child: type.child)
        case .sleep:
            SleepListView(child: type.child)
        case .note:
            Text("note")
        }
    }
}

#Preview {
    NavigationStack {
        RecordTypeView(type: ChildRecordType(child: Child(name: "Name", dob: Date(), gender: ""), recordType: .feed))
    }
}
