//
//  FeedChartView.swift
//  Baby Trackr
//
//  Created by Daniel McFarland on 22/01/2024.
//

import SwiftUI
import SwiftData
import Charts

struct FeedChartView: View {
    var child: Child
    var feedType: FeedType
    var period: ChartPeriod
    
    @Query private var feeds: [Feed]
    
    init(child: Child, feedType: FeedType, period: ChartPeriod) {
        let id = child.persistentModelID
        let periodDate: Date = period.periodDate
        
        self._feeds = Query(filter: #Predicate<Feed> { feed in
            feed.child?.persistentModelID == id &&
            feed.typeValue == feedType.rawValue &&
            feed.createdAt > periodDate
        })
        
        self.child = child
        self.feedType = feedType
        self.period = period
    }
    
    var body: some View {
        Chart(feeds, id: \.breastSide) { feed in
            SectorMark(
                angle: .value("Time", feed.duration),
                innerRadius: .ratio(0.618),
                angularInset: 1.5
                )
            .cornerRadius(5)
            .foregroundStyle(by: .value("Side", feed.breastSide.rawValue))
        }
        .chartXAxis(.hidden)
        .padding()
        .frame(height: 250)
        .animation(.default)
//        .withAnimation()
//        .animation(.interactiveSpring, value: 200)
//        .animation(.default)        .onAppear {
//            for (index, _) in feeds.enumerated() {
//                withAnimation(Animation.interactiveSpring(response: 0.8, dampingFraction: 0.8, blendDuration: 0.8).delay(Double(index) * 0.05)) {
////                    feeds[index].animate = true
//                }
//            }
//        }
    }
}

#Preview {
    FeedChartView(child: Child(name: "", dob: Date.distantPast, gender: ""), feedType: .breast, period: .sevenDays)
}
