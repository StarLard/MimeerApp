//
//  Logger+MimeerWidgets.swift
//  Mimeer Widgets
//
//  Created by Caleb Friden on 8/20/23.
//

import Foundation
import OSLog

extension Logger {
    static let appIntents = Logger(category: "AppIntents")
    static let general = Logger(category: "General")

    init(category: String) {
        self.init(subsystem: "com.starlard.Mimeer.Widgets", category: category)
    }
}
