//
//  MimeerModelContainer.swift
//  MimeerKit
//
//  Created by Caleb Friden on 7/24/23.
//

import Foundation
import OSLog
import StarLardKit
import SwiftData

extension ModelContainer {
    @MainActor
    public static var shared: ModelContainer {
        if let container = _shared {
            return container
        } else {
            fatalError("Attempted to access shared container before initializing")
        }
    }

    @MainActor
    public static func initializeSharedContainer() throws {
        guard _shared == nil else { return }
        let schema = Schema(versionedSchema: MimeerSchemaV1.self)
        let configuration: ModelConfiguration
        #if DEBUG

            #if os(macOS)
                if DeploymentEnvironment.isRunningForUITests || DeploymentEnvironment.isRunningForScreenshots {
                    configuration = .development
                } else {
                    configuration = .production
                }
            #else
                if DeploymentEnvironment.isRunningForPreviews || DeploymentEnvironment.isRunningForUITests
                    || DeploymentEnvironment.isRunningForScreenshots
                {
                    configuration = .development
                } else {
                    configuration = .production
                }
            #endif

        #else
            configuration = .production
        #endif
        let container = try ModelContainer(for: schema, configurations: [configuration])
        Logger.model.debug("Successfully created model container")

        #if DEBUG && !os(macOS)
            if DeploymentEnvironment.isRunningForPreviews || DeploymentEnvironment.isRunningForScreenshots {
                addMocks(to: container.mainContext)
            }
        #elseif DEBUG
            if DeploymentEnvironment.isRunningForScreenshots {
                addMocks(to: container.mainContext)
            }
        #endif

        _shared = container
    }

    @MainActor
    private static var _shared: ModelContainer?

    #if DEBUG

        @MainActor static func addMocks(to modelContext: ModelContext) {
            // Data must be consistent across runs for screenshots and tests

            func createEvents(_ numberOfEvents: Int, seed: Int) -> [Event] {
                var baseUTCTimestamp: TimeInterval =
                    Date.current.timeIntervalSince1970 - (TimeInterval(seed / 2) * .day)
                let offsetVariants = [
                    [
                        TimeInterval.hour - (TimeInterval.minute + 12),
                        (TimeInterval.hour * 2) - (TimeInterval.minute * 45),
                        (TimeInterval.hour * 6) - (TimeInterval.minute * 12),
                        (TimeInterval.hour * 9) - (TimeInterval.minute * 36),
                        (TimeInterval.hour * 12) - (TimeInterval.minute * 2),
                    ],
                    [
                        (TimeInterval.hour * 3) - (TimeInterval.minute * 32),
                        (TimeInterval.hour * 6) - (TimeInterval.minute * 3),
                    ],
                    [
                        (TimeInterval.hour * 1) - (TimeInterval.minute * 5),
                        (TimeInterval.hour * 2) - (TimeInterval.minute * 23),
                        (TimeInterval.hour * 3) - (TimeInterval.minute * 27),
                        (TimeInterval.hour * 5) - (TimeInterval.minute * 13),
                        (TimeInterval.hour * 5) - (TimeInterval.minute * 9),
                        (TimeInterval.hour * 7) - (TimeInterval.minute * 19),
                        (TimeInterval.hour * 8) - (TimeInterval.minute * 49),
                        (TimeInterval.hour * 9) - (TimeInterval.minute * 11),
                        (TimeInterval.hour * 11) - (TimeInterval.minute * 24),
                        (TimeInterval.hour * 13) - (TimeInterval.minute * 31),
                        (TimeInterval.hour * 14) - (TimeInterval.minute * 47),
                        (TimeInterval.hour * 16) - (TimeInterval.minute * 35),
                        (TimeInterval.hour * 16) - (TimeInterval.minute * 57),
                    ],
                    [
                        (TimeInterval.hour * 7) - (TimeInterval.minute + 21),
                        (TimeInterval.hour * 8) - (TimeInterval.minute * 31),
                        (TimeInterval.hour * 9) - (TimeInterval.minute * 33),
                        (TimeInterval.hour * 10) - (TimeInterval.minute * 41),
                        (TimeInterval.hour * 18) - (TimeInterval.minute * 43),
                    ],
                    [
                        (TimeInterval.hour * 14) - (TimeInterval.minute * 51),
                        (TimeInterval.hour * 17) - (TimeInterval.minute * 19),
                    ],
                ]

                var events: [Event] = []
                var eventsCreated = 0
                // Use a random number seed so that the data doesn't look identical for every activity.
                var offsetVariantIndex =
                    seed > 0 ? max(offsetVariants.count, seed) % min(offsetVariants.count, seed) : 0
                var offsetIndex =
                    seed > 0
                    ? max(offsetVariants[offsetVariantIndex].count, seed)
                        % min(offsetVariants[offsetVariantIndex].count, seed) : 0
                while eventsCreated < numberOfEvents {
                    let offsets = offsetVariants[offsetVariantIndex]
                    let offset = offsets[offsetIndex]

                    events.append(Event(timestamp: Date(timeIntervalSince1970: baseUTCTimestamp + offset)))
                    eventsCreated += 1
                    offsetIndex += 1

                    if !offsets.indices.contains(offsetIndex) {
                        offsetIndex = 0
                        offsetVariantIndex += 1
                        baseUTCTimestamp -= .day
                        if !offsetVariants.indices.contains(offsetVariantIndex) {
                            offsetVariantIndex = 0
                        }
                    }
                }
                return events
            }

            let data: [(activity: Activity, events: [Event])] = [
                (
                    activity: Activity(
                        title: "Fold Laundry",
                        icon: .tshirtFill,
                        color: .init(red: 0, green: 0.7804, blue: 0.9765),
                        note: "",
                        displayPriority: 0
                    ),
                    events: createEvents(40, seed: 0)
                ),
                (
                    activity: Activity(
                        title: "Grocery Shop",
                        icon: .cartFill,
                        color: .init(red: 0, green: 0.8863, blue: 0.4118),
                        note: "",
                        displayPriority: 1
                    ),
                    events: createEvents(36, seed: 18)
                ),
                (
                    activity: Activity(
                        title: "Feed Cats",
                        icon: .pawprintFill,
                        color: .init(red: 0.949, green: 0.6784, blue: 0),
                        note: "",
                        displayPriority: 2
                    ),
                    events: createEvents(264, seed: 2)
                ),
                (
                    activity: Activity(
                        title: "Take Out Trash",
                        icon: .trashFill,
                        color: .init(red: 0.4745, green: 0, blue: 0.8863),
                        note: "",
                        displayPriority: 3
                    ),
                    events: createEvents(23, seed: 3)
                ),
                (
                    activity: Activity(
                        title: "Get Gas",
                        icon: .fuelpumpFill,
                        color: .init(red: 1, green: 0, blue: 0.4667),
                        note: "",
                        displayPriority: 4
                    ),
                    events: createEvents(46, seed: 24)
                ),
            ]

            // TODO: Gather screenshots, submit existing to Apple. Follow up with iOS 18 release.

            for activity in data.map(\.activity) {
                modelContext.insert(activity)
            }
            for event in data.map(\.events).reduce(into: [], +=) {
                modelContext.insert(event)
            }

            for tuple in data {
                let activity = tuple.activity
                for event in tuple.events {
                    event.activity = activity
                    activity.events.append(event)
                }
            }
        }
    #endif
}

extension ModelConfiguration {
    @MainActor
    fileprivate static let production: ModelConfiguration = {
        // By default, SwiftData infers the correct configuration
        return ModelConfiguration()
    }()

    #if DEBUG
        @MainActor
        static let development: ModelConfiguration = {
            return ModelConfiguration(isStoredInMemoryOnly: true, groupContainer: .none, cloudKitDatabase: .none)
        }()
    #endif
}
