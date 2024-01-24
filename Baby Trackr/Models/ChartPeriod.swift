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
