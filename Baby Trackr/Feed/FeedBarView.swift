//
//  FeedBarView.swift
//  Baby Trackr
//
//  Created by Daniel McFarland on 23/01/2024.
//

import SwiftUI
import SwiftData
import Charts

struct BarItemData: Equatable {
    let type: String
    let data: [BarItem]
    
    static func == (lhs: BarItemData, rhs: BarItemData) -> Bool {
        rhs.type == lhs.type &&
        rhs.data == lhs.data
    }
}

struct BarItem: Identifiable, Equatable {
    let id = UUID()
    let day: String
    let volume: Int
    
    static func == (lhs: BarItem, rhs: BarItem) -> Bool {
        rhs.day == lhs.day &&
        rhs.volume == lhs.volume
    }
}

extension BarItem {
    static let express: [BarItem] = [
        .init(day: "Mon", volume: 250),
        .init(day: "Tue", volume: 150),
        .init(day: "Wed", volume: 150),
        .init(day: "Thu", volume: 0),
    ]
    
    static let formula: [BarItem] = [
        .init(day: "Mon", volume: 150),
        .init(day: "Tue", volume: 250),
        .init(day: "Wed", volume: 250),
        .init(day: "Thu", volume: 400),
    ]
}

struct FeedBarView: View {
    var child: Child
    var feedType: FeedType
    var period: ChartPeriod
    var placeholderFeeds: [Feed] = []
    
    let barItemData: [BarItemData] = [
        BarItemData(type: "Formula", data: BarItem.formula),
        BarItemData(type: "Express", data: BarItem.express),
    ]
    
    @Query private var feeds: [Feed]
    
    init(child: Child, feedType: FeedType, period: ChartPeriod) {
        let id = child.persistentModelID
        let periodDate: Date = period.periodDate
        
        self._feeds = Query(filter: #Predicate<Feed> { feed in
            feed.child?.persistentModelID == id &&
            feed.typeValue == feedType.rawValue &&
            feed.createdAt > periodDate &&
            !feed.trackrRunning
        })
        
        self.child = child
        self.feedType = feedType
        self.period = period
        
        BreastSide.allCases.forEach { side in
            let feed = Feed(type: .bottle)
            feed.duration = 0
            feed.breastSideValue = side.rawValue
            self.placeholderFeeds.append(feed)
        }
    }
    
    var body: some View {
        Chart(barItemData, id: \.type) { element in
            ForEach(element.data) {
                BarMark(
                    x: .value("Day", $0.day),
                    y: .value("Volume (in ml)", $0.volume)
                )
            }
            .cornerRadius(5)
            .foregroundStyle(by: .value("Side", element.type))
        }
        .chartXAxis(.hidden)
        .padding()
        .padding(.bottom, 0)
        .frame(height: 250)
        .animation(.default, value: barItemData)
    }
}

#Preview {
    FeedBarView(child: Child(name: "", dob: Date.distantPast, gender: ""), feedType: .breast, period: .sevenDays)
}
