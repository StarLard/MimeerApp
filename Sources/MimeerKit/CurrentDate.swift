//
//  CurrentDate.swift
//  MimeerKit
//
//  Created by Caleb Friden on 12/17/24.
//

import Foundation
import SwiftUI

extension Date {
    /// Returns a `Date` initialized to the current date and time, or an overriden value if present.
    @MainActor public static var current: Date {
        #if DEBUG
            if let overridenCurrentDate {
                return overridenCurrentDate
            }
        #endif
        return .now
    }

    #if DEBUG
        @MainActor public static var overridenCurrentDate: Date?
    #endif

    @MainActor public init(timeIntervalSinceCurrentDate: TimeInterval) {
        self.init(timeInterval: timeIntervalSinceCurrentDate, since: .current)
    }

    @MainActor public var timeIntervalSinceCurrentDate: TimeInterval {
        timeIntervalSince(.current)
    }
}

extension EnvironmentValues {
    @Entry public var date: Date = .now
}

extension Scene {
    public func date(_ date: Date) -> some Scene {
        environment(\.date, date)
    }
}
