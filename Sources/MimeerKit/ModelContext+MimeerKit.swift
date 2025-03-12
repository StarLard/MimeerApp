//
//  ModelContext+MimeerKit.swift
//  MimeerKit
//
//  Created by Caleb Friden on 8/20/23.
//

import Foundation
import OSLog
import SwiftData
import SwiftUI
import WidgetKit

extension ModelContext {
    /// Creates and inserts a new `Event`.
    /// - Parameters:
    ///   - date: The date of the new event. Defaults to `.now`.
    ///   - activity: The activity to  which the event beloongs.
    /// - Returns: The newly created event.
    @discardableResult
    public func insertNewEvent(at date: Date = .now, duration: TimeInterval? = nil, for activity: Activity) -> Event {
        let newEvent = Event(timestamp: date)
        newEvent.duration = duration
        Logger.model.info("Inserting new event")
        insert(newEvent)
        newEvent.activity = activity
        activity.events.append(newEvent)
        WidgetCenter.shared.reloadAllTimelines()
        return newEvent
    }

    /// Creates and inserts a new `Activity`.
    /// - Parameters:
    ///   - title: The title for the new activity.
    ///   - icon: The icon for the new activity.
    ///   - color: The color for the new activity.
    ///   - note: The note for the new activity.
    ///   - displayPriority: The display priority for the new activity.
    /// - Returns: The newly created activity.
    @discardableResult
    public func insertNewActivity(
        title: String,
        icon: SFSymbol,
        color: Color.Resolved,
        note: String,
        displayPriority: UInt
    ) -> Activity {
        let newActivity = Activity(title: title, icon: icon, color: color, note: note, displayPriority: displayPriority)
        Logger.model.info("Inserting new activity")
        insert(newActivity)
        return newActivity
    }

    public func syncWidgets() {
        // Needed until ModelContext notifications are not bugged. Then this work can be done there.
        WidgetCenter.shared.reloadAllTimelines()
    }
}

public struct ModelContextKey: FocusedValueKey {
    public typealias Value = ModelContext
}

extension FocusedValues {
    public var modelContext: ModelContextKey.Value? {
        get { self[ModelContextKey.self] }
        set { self[ModelContextKey.self] = newValue }
    }
}
