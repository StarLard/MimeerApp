//
//  LastlyModelContainer.swift
//  Lastly
//
//  Created by Caleb Friden on 7/24/23.
//

import Foundation
import MimeerKit
import OSLog
import StarLardKit
import SwiftData

extension ModelContainer {
    @MainActor
    static let shared: ModelContainer = {
        do {
            let schema = Schema(versionedSchema: LastlySchemaV1.self)
            let configuration: ModelConfiguration
            #if DEBUG
                if DeploymentEnvironment.isRunningForPreviews || DeploymentEnvironment.isRunningForUITests {
                    configuration = .development
                } else {
                    configuration = .production
                }
            #else
                configuration = .production
            #endif
            let container = try ModelContainer(for: schema, configurations: [configuration])
            Logger.model.debug("Successfully created model container")

            #if DEBUG
                if DeploymentEnvironment.isRunningForPreviews {
                    for item in Mocks.taskItems {
                        container.mainContext.insert(item)
                    }
                    for event in Mocks.taskItemEvents {
                        container.mainContext.insert(event)
                    }
                    var events = Mocks.taskItemEvents
                    var counter = 0

                    while let event = events.popLast() {
                        let item: TaskItem
                        if counter == 0 {
                            item = Mocks.taskItems[4]
                        } else {
                            item = Mocks.taskItems[counter % 2]
                        }
                        event.item = item
                        item.events?.append(event)
                        counter += 1
                    }
                }
            #endif

            return container
        } catch {
            Logger.model.critical(
                "Failed to create model container with error: \(error.localizedDescription, privacy: .public)")
            DiagnosticReporter.shared.recordError(error, level: .fault)
            fatalError("Failed to create model container with error: \(error.localizedDescription)")
        }
    }()
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
