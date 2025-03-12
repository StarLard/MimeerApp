//
//  DateFilter.swift
//  MimeerApp
//
//  Created by Caleb Friden on 8/30/23.
//

import Foundation
import SwiftUI

enum DateFilter: CaseIterable {
    case today
    case yesterday
    case week
    case month
    case all

    var title: LocalizedStringKey {
        switch self {
        case .today:
            return "Today"
        case .yesterday:
            return "Yesterday"
        case .week:
            return "Week"
        case .month:
            return "Month"
        case .all:
            return "All"
        }
    }

    var filteringGranularity: Calendar.Component? {
        switch self {
        case .today, .yesterday:
            return .day
        case .week:
            return .weekOfYear
        case .month:
            return .month
        case .all:
            return .none
        }
    }

    var displayGranularity: Calendar.Component {
        switch self {
        case .today, .yesterday:
            return .hour
        case .week, .month, .all:
            return .day
        }
    }

    var groupingComponents: Set<Calendar.Component> {
        switch self {
        case .today, .yesterday:
            return [.hour, .day, .month, .year]
        case .week, .month, .all:
            return [.day, .month, .year]
        }
    }

    var frequencyUnit: LocalizedStringKey {
        switch self {
        case .today, .yesterday:
            "TIMES/HOUR"
        case .week, .month, .all:
            "TIMES/DAY"
        }
    }

    func format(date: Date, locale: Locale) -> String {
        switch self {
        case .today, .yesterday:
            return date.formatted(.dateTime.hour().locale(locale))
        case .week:
            return date.formatted(.dateTime.weekday().locale(locale))
        case .month, .all:
            return date.formatted(.dateTime.month().day().locale(locale))
        }
    }
}
