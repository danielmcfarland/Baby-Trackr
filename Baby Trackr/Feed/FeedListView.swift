//
//  FeedListView.swift
//  Baby Trackr
//
//  Created by Daniel McFarland on 17/01/2024.
//

import SwiftUI
import SwiftData

enum ChartPeriod: String, CaseIterable, Codable, Identifiable {
    case oneDay = "1 Day"
    case sevenDays = "7 Days"
    case twentyEightDays = "28 Days"
    case allTime = "All"
    
    var id: Self { self }
    
    var periodDate: Date {
        switch self {
        case .oneDay:
            return Calendar.current.startOfDay(for: Date())
        case .sevenDays:
            return Calendar.current.date(byAdding: .day, value: -7, to: ChartPeriod.oneDay.periodDate)!
        case .twentyEightDays:
            return Calendar.current.date(byAdding: .day, value: -28, to: ChartPeriod.oneDay.periodDate)!
        case .allTime:
            return Date.distantPast
        }
    }
}

struct FeedListView: View {
    var child: Child
    var feedType: FeedType
    
    @Query private var feeds: [Feed]
    
    @State var period: ChartPeriod = ChartPeriod.sevenDays
    
    init(child: Child, feedType: FeedType) {
        let id = child.persistentModelID
        
        self._feeds = Query(filter: #Predicate<Feed> { feed in
            feed.child?.persistentModelID == id &&
            feed.typeValue == feedType.rawValue
        }, sort: \.createdAt, order: .reverse)
        
        self.child = child
        self.feedType = feedType
    }
    
    var body: some View {
        List {
            Picker("Chart Period", selection: $period) {
                ForEach(ChartPeriod.allCases) { period in
                    Text(period.rawValue).tag(period)
                }
            }
            .pickerStyle(.segmented)
            .padding(0)
            .listRowInsets(.none)
            .listRowBackground(Color.clear)
            .listRowSpacing(0)
            .listRowSeparator(.hidden)
            
            if feedType == .breast {
                FeedChartView(child: child, feedType: feedType, period: period)
                    .listRowInsets(.none)
                    .listRowBackground(Color.clear)
                    .listRowSpacing(0)
                    .listRowSeparator(.hidden)
            }
            
            if feedType == .bottle {
                FeedChartView(child: child, feedType: feedType, period: period)
                    .listRowInsets(.none)
                    .listRowBackground(Color.clear)
                    .listRowSpacing(0)
                    .listRowSeparator(.hidden)
            }
            //            List {
            Section() {
                ForEach(feeds) { feed in
                    NavigationLink(value: feed) {
                        HStack {
                            if feed.type == .bottle {
                                Text("\(feed.bottleSize.rawValue)")
                            } else if feed.type == .breast && !feed.trackrRunning {
                                Text("\(feed.humanReadableDuration)")
                            } else if feed.type == .breast && feed.trackrRunning {
                                HStack {
                                    Image(systemName: "record.circle")
                                        .foregroundStyle(Color.red)
                                    Text("In Progress")
                                }
                            }
                            Spacer()
                            Text(feed.createdAt, format: Date.FormatStyle(date: .abbreviated, time: .shortened))
                                .foregroundStyle(Color.gray)
                        }
                        //                        }
                    }
                }
            }
        }
        .listStyle(DefaultListStyle())
    }
}

#Preview {
    NavigationStack {
        FeedListView(child: Child(name: "Name", dob: Date(), gender: ""), feedType: .breast)
    }
}
