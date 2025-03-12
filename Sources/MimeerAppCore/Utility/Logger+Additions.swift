//
//  Logger+Additions.swift
//  MimeerApp
//
//  Created by Caleb Friden on 7/23/23.
//

import Foundation
import OSLog
import Observation

extension Logger {
    public static let general = Logger(category: "General")

    public init(category: String) {
        self.init(subsystem: Bundle.main.bundleIdentifier!, category: category)
    }
}

extension OSLogEntryLog {
    func formatted() -> String {
        "[\(date.formatted())] [\(self.category)] \(composedMessage)"
    }
}

@Observable final class LogStore {
    private(set) var entries: [OSLogEntryLog] = []

    init(
        subsystem: String = Bundle.main.bundleIdentifier!,
        strategy: PositionStrategy,
        timeinterval: TimeInterval
    ) throws {
        self.subsystem = subsystem
        self.store = try OSLogStore(scope: .currentProcessIdentifier)
        switch strategy {
        case .sinceEnd:
            self.position = store.position(timeIntervalSinceEnd: timeinterval)
        case .sinceLatestBoot:
            self.position = store.position(timeIntervalSinceLatestBoot: timeinterval)
        }
    }

    enum PositionStrategy {
        case sinceLatestBoot
        case sinceEnd
    }

    func getEntries() throws {
        entries =
            try store
            .getEntries(at: position)
            .compactMap { $0 as? OSLogEntryLog }
            .filter { $0.subsystem == subsystem }
    }

    private let store: OSLogStore
    private let position: OSLogPosition
    private let subsystem: String
}
