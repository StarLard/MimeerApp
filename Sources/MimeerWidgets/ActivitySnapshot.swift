//
//  ActivitySnapshot.swift
//  Mimeer WidgetsExtension
//
//  Created by Caleb Friden on 8/21/23.
//

import Foundation
import MimeerKit
import SwiftUI

struct ActivitySnapshot {
    var date: Date
    var id: Activity.ID
    var title: String
    var lastEvent: Date?
    var color: Color.Resolved
    var icon: SFSymbol
    var recentEvents: [Date]
}

extension ActivitySnapshot {
    // We can't just use Activity.events because they don't seem to be populated when queried from widget
    init(date: Date, activity: Activity, recentEvents: [Event]) {
        self.date = date
        self.id = activity.id
        self.title = activity.title
        self.lastEvent = activity.lastEvent?.timestamp
        self.color = activity.color
        self.icon = activity.icon
        self.recentEvents = recentEvents.map(\.timestamp)
    }
}

extension ActivitySnapshot {
    public static func snapshots(
        for activity: Activity,
        recentEvents: [Event],
        through date: Date
    ) async -> [ActivitySnapshot] {
        // Initial state.
        let initial = ActivitySnapshot(date: .now, activity: activity, recentEvents: recentEvents)
        var snapshots: [ActivitySnapshot] = [initial]

        // Add general time of day transitions.

        // Every 5 minutes for the first hour
        for timeInterval in stride(
            from: 0, through: min(Date.now.addingTimeInterval(.hour), date).timeIntervalSinceNow,
            by: 5 * .minute)
        {
            await snapshots.append(
                ActivitySnapshot(
                    date: Date(timeIntervalSinceCurrentDate: timeInterval), activity: activity,
                    recentEvents: recentEvents))
        }

        // Hourly thereafter
        for timeInterval in stride(from: 0, through: date.timeIntervalSinceNow, by: .hour) {
            await snapshots.append(
                ActivitySnapshot(
                    date: Date(timeIntervalSinceCurrentDate: timeInterval), activity: activity,
                    recentEvents: recentEvents))
        }

        return snapshots
    }
}
