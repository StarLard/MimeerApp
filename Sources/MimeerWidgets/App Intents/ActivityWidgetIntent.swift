//
//  ActivityWidgetIntent.swift
//  Mimeer WidgetsExtension
//
//  Created by Caleb Friden on 8/21/23.
//

import AppIntents
import Foundation

struct ActivityWidgetIntent: WidgetConfigurationIntent {
    static let title: LocalizedStringResource = "Activity"
    static let description = IntentDescription("Log events for an activity with one quick tap.")

    @Parameter(title: "Activity")
    var activity: ActivityEntity?

    init(activity: ActivityEntity? = nil) {
        self.activity = activity
    }

    init() {
    }

    static var parameterSummary: some ParameterSummary {
        Summary {
            \.$activity
        }
    }
}
