//
//  ActivityInsightsSummary.swift
//  MimeerApp
//
//  Created by Caleb Friden on 8/30/23.
//

import Foundation
import MimeerKit
import SwiftUI

struct ActivityInsightsSummary {
    struct DataPoint: Equatable {
        var date: Date
        var numberOfEvents: Int
    }

    let activity: Activity
    let dateFilter: DateFilter
    let calendar: Calendar
    let filteredEvents: [Event]
    let eventsByDate: [DateComponents: [Event]]
    let dataPoints: [DataPoint]
    let averageFrequency: Double
    let averageInterval: Double
    let averageIntervalUnitized: (value: Double, unit: LocalizedStringKey)

    init(activity: Activity, dateFilter: DateFilter, calendar: Calendar, now: Date) {
        self.activity = activity
        self.dateFilter = dateFilter
        self.calendar = calendar

        let events = activity.events
        let yesterday: Date

        do {
            yesterday = calendar.startOfDay(
                for: try calendar.date(byAdding: .day, value: -1, to: now).unwrap())
        } catch {
            Task.detached { @MainActor in
                DiagnosticReporter.shared.recordError(error, assertOnSimulator: true)
            }
            yesterday = calendar.startOfDay(for: now.addingTimeInterval(.day / 2))
        }

        filteredEvents =
            dateFilter.filteringGranularity.flatMap { calendarGranularity in
                events.filter { event in
                    calendar.isDate(
                        event.timestamp,
                        equalTo: dateFilter == .yesterday ? yesterday : now,
                        toGranularity: calendarGranularity
                    )
                }
            } ?? events

        eventsByDate = Dictionary(grouping: filteredEvents) { event in
            calendar.dateComponents(dateFilter.groupingComponents, from: event.timestamp)
        }

        let startingDate: Date
        let endingDate: Date
        let strideInterval: TimeInterval

        switch dateFilter {
        case .today:
            startingDate = calendar.startOfDay(for: now)
            endingDate = now
            strideInterval = TimeInterval.hour
        case .yesterday:
            startingDate = yesterday
            endingDate = calendar.startOfDay(for: now)
            strideInterval = TimeInterval.hour
        case .week:
            startingDate = calendar.startOfWeek(for: now)
            endingDate = now
            strideInterval = TimeInterval.day
        case .month:
            startingDate = calendar.startOfMonth(for: now)
            endingDate = now
            strideInterval = TimeInterval.day
        case .all:
            startingDate =
                filteredEvents.min(by: { lhs, rhs in
                    lhs.timestamp < rhs.timestamp
                })?.timestamp ?? calendar.startOfWeek(for: now)
            endingDate = now
            strideInterval = TimeInterval.day
        }

        var dataPoints: [DataPoint] = []
        for timeInterval in stride(
            from: startingDate.timeIntervalSince(now),
            through: endingDate.timeIntervalSince(now),
            by: strideInterval
        ) {
            let date = Date(timeInterval: timeInterval, since: now)
            let numberOfEvents =
                eventsByDate[calendar.dateComponents(dateFilter.groupingComponents, from: date)]?
                .count ?? 0
            let dataPoint = DataPoint(date: date, numberOfEvents: numberOfEvents)
            dataPoints.append(dataPoint)

        }
        self.dataPoints = dataPoints

        averageFrequency =
            filteredEvents.isEmpty
            ? 0
            : (Double(dataPoints.map(\.numberOfEvents).reduce(into: 0, +=))
                / Double(dataPoints.count)).rounded(toPlaces: 1)

        if filteredEvents.count <= 1 {
            averageInterval = 0
        } else {
            let sortedEvents = filteredEvents.sorted(using: SortDescriptor(\Event.timestamp))
            var intervals: [TimeInterval] = []
            for index in sortedEvents.indices {
                guard index != 0 else { continue }
                let event = sortedEvents[index]
                let previousEvent = sortedEvents[index - 1]
                intervals.append(event.timestamp.timeIntervalSince(previousEvent.timestamp))
            }
            averageInterval = Double(intervals.reduce(into: 0, +=)) / Double(intervals.count)
        }

        if averageInterval < .minute {
            averageIntervalUnitized = (averageInterval, "SECONDS")
        } else if averageInterval < .hour {
            averageIntervalUnitized = ((averageInterval / .minute).rounded(toPlaces: 1), "MINUTES")
        } else if averageInterval <= .day * 2 {
            averageIntervalUnitized = ((averageInterval / .hour).rounded(toPlaces: 1), "HOURS")
        } else {
            averageIntervalUnitized = ((averageInterval / .day).rounded(toPlaces: 1), "DAYS")
        }
    }
}
