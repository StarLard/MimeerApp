//
//  LastlySchema.swift
//  Lastly
//
//  Created by Caleb Friden on 7/24/23.
//

import Foundation
import MimeerKit
import SwiftData
import SwiftUI

// Keep pointed to the current versions
typealias TaskItem = LastlySchemaV1.TaskItem
typealias TaskItemEvent = LastlySchemaV1.TaskItemEvent

enum LastlySchemaV1: VersionedSchema {
    static let versionIdentifier = Schema.Version(1, 0, 0)

    static var models: [any PersistentModel.Type] {
        [Self.TaskItem.self, Self.TaskItemEvent.self]
    }

    @Model
    final class TaskItem {
        /// The time the item was created
        //        let created: Date = Date.now
        var created: Date

        /// The user-selected time associated with the item.
        @Relationship(deleteRule: .cascade, inverse: \TaskItemEvent.item)
        var events: [LastlySchemaV1.TaskItemEvent]?

        /// The title of the item
        //        var title: String = ""
        var title: String

        /// The system icon to display for the item
        //        var icon: SFSymbol = SFSymbol.sparkles
        var icon: SFSymbol

        // This currently crashes in beta 6
        //        /// The color to display for the item
        //        var color: Color.Resolved

        /// The red component in the standard sRGB color space on a range of 0 to 1 of the color to display for the item
        //        var red: Float = 0
        var red: Float

        /// The green component in the standard sRGB color space on a range of 0 to 1 of the color to display for the item
        //        var green: Float = 0
        var green: Float

        /// The blue component in the standard sRGB color space on a range of 0 to 1 of the color to display for the item
        //        var blue: Float = 0
        var blue: Float

        /// The priority used to display for the item
        //        var displayPriority: UInt = 0
        var displayPriority: UInt

        /// A note about the item
        //        var note: String = ""
        var note: String

        var color: Color.Resolved {
            get {
                Color.Resolved(red: red, green: green, blue: blue)
            }
            set {
                red = newValue.red
                green = newValue.green
                blue = newValue.blue
            }
        }

        /// The most recent event
        var lastEvent: TaskItemEvent? {
            events?.sorted(using: SortDescriptor(\TaskItemEvent.timestamp, order: .forward)).last
        }

        init(
            title: String,
            icon: SFSymbol,
            color: Color.Resolved,
            note: String,
            displayPriority: UInt
        ) {
            self.created = .now
            self.events = []
            self.title = title
            self.icon = icon
            self.note = note
            self.displayPriority = displayPriority
            self.red = color.red
            self.green = color.green
            self.blue = color.blue
        }
    }

    @Model
    final class TaskItemEvent {
        /// The time the event was created
        //        let created: Date = Date.now
        var created: Date

        /// The user-selected time associated with the event.
        //        var timestamp: Date = Date.now
        var timestamp: Date

        /// The item for which this event occured
        var item: LastlySchemaV1.TaskItem?

        init(timestamp: Date) {
            self.created = .now
            self.timestamp = timestamp
        }
    }
}
