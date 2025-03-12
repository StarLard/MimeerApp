//
//  Logger+MimeerKit.swift
//
//
//  Created by Caleb Friden on 8/20/23.
//

import Foundation
import OSLog

extension Logger {
    public static let model = Logger(category: "Model")

    public init(category: String) {
        self.init(subsystem: "com.starlard.MimeerKit", category: category)
    }
}
