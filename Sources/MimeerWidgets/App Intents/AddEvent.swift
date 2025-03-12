//
//  AddEvent.swift
//  Mimeer Widgets
//
//  Created by Caleb Friden on 8/18/23.
//

import AppIntents
import Foundation
import MimeerKit
import OSLog
import SwiftData

struct AddEvent: AppIntent {
    static let title: LocalizedStringResource = "Log an event for an activity"
    static let description = IntentDescription("Logs a new event at a given time to an activity.")

    @Parameter(title: "Activity")
    var activityEntity: ActivityEntity

    @Parameter(title: "Event Date")
    var eventTimestamp: Date?

    @Parameter(title: "Event Duration")
    var eventDuration: TimeInterval?

    init() {
        Task { @MainActor in
            do {
                try ModelContainer.initializeSharedContainer()
            } catch {
                Logger.appIntents.critical(
                    "Failed to create model container with error: \(error.localizedDescription, privacy: .public)"
                )
            }
        }
    }

    @MainActor
    func perform() async throws -> some IntentResult {
        Logger.appIntents.info("Performing app intent \"\(AddEvent.title.key, privacy: .public)\"")

        // Fetch the matching activity
        let activityID = activityEntity.id
        let predicate = #Predicate<Activity> { activity in
            activity.id == activityID
        }
        let descriptor = FetchDescriptor<Activity>(
            predicate: predicate,
            sortBy: [SortDescriptor(\Activity.displayPriority), SortDescriptor(\Activity.title)])
        let modelContext = ModelContext(ModelContainer.shared)
        let activities = try modelContext.fetch(descriptor)
        assert(activities.count == 1)
        guard let activity = activities.first else { return .result() }
        // Create, add, and save the event
        modelContext.insertNewEvent(
            at: eventTimestamp ?? .current, duration: eventDuration, for: activity)
        try modelContext.save()
        return .result()
    }

    static var parameterSummary: some ParameterSummary {
        Summary("Log event at \(\.$eventTimestamp) to \(\.$activityEntity)")
    }
}
