//
//  ActivityEntity.swift
//  Mimeer Widgets
//
//  Created by Caleb Friden on 8/18/23.
//

import AppIntents
import Foundation
import MimeerKit
import OSLog
import SwiftData

struct ActivityEntity: AppEntity, Identifiable {
    init(id: Activity.ID, title: String, lastEvent: Date?) {
        self.id = id
        self.title = title
        self.lastEvent = lastEvent
    }

    init(activity: Activity) {
        self.id = activity.id
        self.title = activity.title
        self.lastEvent = activity.lastEvent?.timestamp
    }

    var id: Activity.ID

    @Property(title: "Title")
    var title: String

    @Property(title: "Last Event")
    var lastEvent: Date?

    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(title: "\(title)")
    }

    static let typeDisplayRepresentation: TypeDisplayRepresentation = "Activity"

    static let defaultQuery = ActivityQuery()
}
