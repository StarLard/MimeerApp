//
//  ActivitySnapshotTimelineProvider.swift
//  Mimeer WidgetsExtension
//
//  Created by Caleb Friden on 8/21/23.
//

import AppIntents
import Foundation
import MimeerKit
import OSLog
import SwiftData
import SwiftUI
import WidgetKit

struct ActivitySnapshotTimelineProvider: AppIntentTimelineProvider {
    let modelContext: ModelContext

    @MainActor
    init() {
        do {
            try ModelContainer.initializeSharedContainer()
        } catch {
            Logger.appIntents.critical(
                "Failed to create model container with error: \(error.localizedDescription, privacy: .public)"
            )
        }
        self.modelContext = ModelContext(ModelContainer.shared)
    }

    func activity(with id: UUID) -> Activity? {
        Logger.general.info(
            "Fetching activity for widget \(id.uuidString, privacy: .sensitive(mask: .hash))")
        do {
            return try modelContext.fetch(
                FetchDescriptor<Activity>(predicate: #Predicate { $0.id == id })
            ).first
        } catch {
            Logger.general.error(
                "Failed to fetch activity (ID: \(id.uuidString, privacy: .sensitive(mask: .hash))) with error: \(error.localizedDescription, privacy: .public)"
            )
            return nil
        }
    }

    func events(forActivityWithID id: UUID) -> [Event] {
        Logger.general.info(
            "Fetching events for widget \(id.uuidString, privacy: .sensitive(mask: .hash))")
        do {
            var fetchDescriptor = FetchDescriptor<Event>(
                predicate: #Predicate<Event> { event in
                    event.activity?.id == id
                },
                sortBy: [SortDescriptor(\.timestamp, order: .reverse)]
            )
            fetchDescriptor.fetchLimit = 16
            return Array(try modelContext.fetch(fetchDescriptor))
        } catch {
            Logger.general.error(
                "Failed to fetch events for activity (ID: \(id.uuidString, privacy: .sensitive)) with error: \(error.localizedDescription, privacy: .public)"
            )
            return []
        }
    }

    func placeholder(in context: Context) -> ActivityWidgetEntry {
        do {
            guard
                let activity = try modelContext.fetch(
                    FetchDescriptor<Activity>(sortBy: [SortDescriptor(\.displayPriority)])
                ).first
            else {
                let sampleSnapshot = ActivitySnapshot(
                    date: .now,
                    id: UUID(),
                    title: String(localized: "Tidy Up", comment: "Activity title for widget placeholder"),
                    lastEvent: Date.init(timeIntervalSinceNow: -5 * .minute),
                    color: Color.Resolved(red: 162 / 255, green: 228 / 255, blue: 184 / 255),
                    icon: .sparkles,
                    recentEvents: Array(
                        stride(
                            from: Date(timeIntervalSinceNow: -30 * .day).timeIntervalSinceNow,
                            through: -5,
                            by: 1.15 * .day
                        )
                        .map(Date.init(timeIntervalSinceNow:))
                        .reversed()
                    )
                )
                return ActivityWidgetEntry(date: .now, snapshot: sampleSnapshot)
            }

            let recentEvents = events(forActivityWithID: activity.id)

            return ActivityWidgetEntry(
                date: .now,
                snapshot: ActivitySnapshot(date: .now, activity: activity, recentEvents: recentEvents))
        } catch {
            Logger.general.error(
                "Failed to fetch activities with error: \(error.localizedDescription, privacy: .public)")
            return ActivityWidgetEntry(date: .now)
        }
    }

    func snapshot(for configuration: ActivityWidgetIntent, in context: Context) async
        -> ActivityWidgetEntry
    {
        let date = await Date.current
        guard let id = configuration.activity?.id, let activity = activity(with: id) else {
            if context.isPreview {
                return placeholder(in: context)
            } else {
                return ActivityWidgetEntry(date: date)
            }
        }
        let recentEvents = events(forActivityWithID: id)
        let snapshot = ActivitySnapshot(date: date, activity: activity, recentEvents: recentEvents)
        return ActivityWidgetEntry(date: snapshot.date, snapshot: snapshot)
    }

    func timeline(for configuration: ActivityWidgetIntent, in context: Context) async -> Timeline<
        ActivityWidgetEntry
    > {
        guard let id = configuration.activity?.id, let activity = activity(with: id) else {
            let date = await Date.current
            return Timeline(
                entries: [ActivityWidgetEntry(date: date)],
                policy: .never
            )
        }
        let recentEvents = events(forActivityWithID: id)
        let snapshots = await ActivitySnapshot.snapshots(
            for: activity, recentEvents: recentEvents,
            through: Date(timeIntervalSinceCurrentDate: 36 * .hour))
        let entries = snapshots.map { snapshot in
            ActivityWidgetEntry(date: snapshot.date, snapshot: snapshot)
        }
        return Timeline(entries: entries, policy: .atEnd)
    }

    func recommendations() -> [AppIntentRecommendation<ActivityWidgetIntent>] {
        []
    }
}
