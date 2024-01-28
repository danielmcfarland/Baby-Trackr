//
//  ChartPeriod.swift
//  Baby Trackr
//
//  Created by Daniel McFarland on 24/01/2024.
//

import Foundation

enum ChartPeriod: String, CaseIterable, Codable, Identifiable {
    case oneDay = "1 Day"
    case sevenDays = "7 Days"
    case twentyEightDays = "28 Days"
    case allTime = "1 Year"
    
    var id: Self { self }
    
    var startDate: Date {
        switch self {
        case .oneDay:
            return Calendar.current.startOfDay(for: Date.now)
        case .sevenDays:
            return Calendar.current.date(byAdding: .day, value: 1-self.numberOfDays, to: Date.now)!
        case .twentyEightDays:
            return Calendar.current.date(byAdding: .day, value: 1-self.numberOfDays, to: Date.now)!
        case .allTime:
            return Calendar.current.date(byAdding: .year, value: -1, to: Date.now)!
        }
    }
    
    var numberOfDays: Int {
        switch self {
        case .oneDay:
            return 1
        case .sevenDays:
            return 7
        case .twentyEightDays:
            return 28
        case .allTime:
            return 365
        }
    }
}
