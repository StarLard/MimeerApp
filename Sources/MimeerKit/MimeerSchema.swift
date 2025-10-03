//
//  MimeerSchema.swift
//  MimeerKit
//
//  Created by Caleb Friden on 7/24/23.
//

import Foundation
import SwiftData
import SwiftUI

// Keep pointed to the current versions
public typealias Activity = MimeerSchemaV1.Activity
public typealias Event = MimeerSchemaV1.Event

public enum MimeerSchemaV1: VersionedSchema {
    public static let versionIdentifier = Schema.Version(1, 0, 0)

    public static var models: [any PersistentModel.Type] {
        [Self.Activity.self, Self.Event.self]
    }

    @Model
    public final class Activity {
        /// A unique identifier
        public private(set) var id: UUID = UUID()

        /// The time the activity was created
        public private(set) var created: Date = Date.now

        /// The user-selected time associated with the activity.
        @Relationship(deleteRule: .cascade, inverse: \MimeerSchemaV1.Event.activity)
        var _events: [MimeerSchemaV1.Event]? = []

        /// The user-selected time associated with the activity.
        public var events: [MimeerSchemaV1.Event] {
            get {
                _events ?? []
            }
            set {
                _events = newValue.isEmpty ? nil : newValue
            }
        }

        /// The title of the activity
        public var title: String = ""

        /// The system icon to display for the activity
        public var icon: SFSymbol = SFSymbol.sparkles

        // This currently crashes in beta 6
        //        /// The color to display for the activity
        //        var color: Color.Resolved

        /// The red component in the standard sRGB color space on a range of 0 to 1 of the color to display for the activity
        public var red: Float = 0

        /// The green component in the standard sRGB color space on a range of 0 to 1 of the color to display for the activity
        public var green: Float = 0

        /// The blue component in the standard sRGB color space on a range of 0 to 1 of the color to display for the activity
        public var blue: Float = 0

        /// The priority used to display for the activity
        public var displayPriority: UInt = 0

        /// A note about the activity
        public var note: String = ""

        public var color: Color.Resolved {
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
        public var lastEvent: Event? {
            events.sorted(using: SortDescriptor(\MimeerSchemaV1.Event.timestamp, order: .forward)).last
        }

        public init(
            title: String,
            icon: SFSymbol,
            color: Color.Resolved,
            note: String,
            displayPriority: UInt
        ) {
            self.title = title
            self.icon = icon
            self.color = color
            self.note = note
            self.displayPriority = displayPriority
        }
    }

    @Model
    public final class Event {
        /// A unique identifier
        public private(set) var id: UUID = UUID()

        /// The time the event was created.
        public private(set) var created: Date = Date.now

        /// The user-selected time associated with the event.
        public var timestamp: Date = Date.now

        /// The activity for which this event occured.
        public var activity: MimeerSchemaV1.Activity?

        /// How long the event lasted.
        public var duration: TimeInterval?

        /// A note about the event
        public var note: String = ""

        public init(timestamp: Date) {
            self.id = UUID()
            self.created = .now
            self.timestamp = timestamp
        }

        public func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
    }
}
