//
//  DiagnosticReporter.swift
//  MimeerApp
//
//  Created by Caleb Friden on 7/27/23.
//

import Foundation
import OSLog
import Sentry
import StarLardKit

@MainActor
final class DiagnosticReporter {
    // MARK: Public

    static let shared = DiagnosticReporter()

    private(set) var isRunning = false

    #if DEBUG && targetEnvironment(simulator)
        /// While `true` reporter will make trigger assertion failures for errors.
        var shouldErrorsTriggerAssertionFailure = false
    #endif

    func recordError(
        _ error: Error,
        level: OSLogType = .error,
        assertOnSimulator: Bool = false,
        function: StaticString = #function,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        guard isRunning else { return }
        logger.log(level: level, "Error: \(error.localizedDescription)")

        if !DeploymentEnvironment.isRunningForPreviews {
            logger.debug("Error captured: \(error.localizedDescription)")
            recentSentryEventID =
                SentrySDK.capture(error: error) { scope in
                    scope.setLevel(level.sentryLevel)
                }.sentryIdString
        }

        #if DEBUG && targetEnvironment(simulator)
            if shouldErrorsTriggerAssertionFailure || assertOnSimulator {
                assertionFailure("Error: \(error)", file: file, line: line)
            }
        #endif
    }

    func recordError(
        _ errorDescription: String,
        level: OSLogType = .error,
        assertOnSimulator: Bool = false,
        function: StaticString = #function,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        guard isRunning else { return }
        logger.log(level: level, "Error: \(errorDescription)")

        if !DeploymentEnvironment.isRunningForPreviews {
            logger.debug("Error captured: \(errorDescription)")

            recentSentryEventID =
                SentrySDK.capture(message: errorDescription) { scope in
                    scope.setLevel(level.sentryLevel)
                }.sentryIdString
        }

        #if DEBUG && targetEnvironment(simulator)
            if shouldErrorsTriggerAssertionFailure || assertOnSimulator {
                assertionFailure("Error: \(errorDescription)", file: file, line: line)
            }
        #endif
    }

    func captureUserFeedback(name: String, email: String, comments: String) {
        let feedbackEventID =
            recentSentryEventID.map(SentryId.init(uuidString:))
            ?? SentrySDK.capture(message: "user-feedback")
        let feedback = SentryFeedback(
            message: comments,
            name: name,
            email: email,
            source: .custom,
            associatedEventId: feedbackEventID
        )
        SentrySDK.capture(feedback: feedback)
    }

    func start() {
        guard !isRunning else { return }
        logger.debug("Starting diagnostic reporter")
        defer { isRunning = true }
        #if DEBUG
            guard !DeploymentEnvironment.isRunningForPreviews else { return }
        #endif
        SentrySDK.start { options in
            logger.log("Started Sentry SDK")
            options.dsn =
                "https://bf005a4bfc1f4cfab7bcbc4611bf68b4@o712056.ingest.sentry.io/4505605123080192"
            options.environment = DeploymentEnvironment.current.description
            options.enableAutoSessionTracking = true
            options.attachStacktrace = true  // Attaches stacktraces to non-fatals too.
            options.sessionTrackingIntervalMillis = 3 * 60 * 1000  // 3 minutes
            #if DEBUG
                options.debug = true
            #endif
            switch DeploymentEnvironment.current {
            case .development, .testing:
                options.maxBreadcrumbs = 500
                options.tracesSampleRate = 1.0
            case .production:
                options.tracesSampleRate = 0.25
            }

            options.beforeSend = { [weak self] event in
                self?.attachLogsToSentry()
                return event
            }
            options.onCrashedLastRun = { [weak self] event in
                let eventID = event.eventId.sentryIdString
                MainActor.assumeIsolated {
                    if Thread.isMainThread {
                        self?.recentSentryEventID = eventID
                    } else {
                        DispatchQueue.main.sync {
                            self?.recentSentryEventID = eventID
                        }
                    }
                }
            }
        }

        SentrySDK.configureScope { scope in
            scope.setTags([
                "Bundle Identifier": AppInfo.bundleIdentifier,
                "Bundle Version": AppInfo.versionString,
                "Locale": Locale.current.identifier,
            ])
        }
    }

    func stop() {
        guard isRunning else { return }
        defer { isRunning = false }
        logger.debug("Stopping diagnostic reporter")
        #if DEBUG
            guard !DeploymentEnvironment.isRunningForPreviews else { return }
        #endif
        SentrySDK.close()
        logger.log("Closed Sentry SDK")
    }

    #if DEBUG
        func forceCrash() {
            assert(isRunning, "Attempted to call \(#function) before start() has been called")
            SentrySDK.crash()
        }
    #endif

    // MARK: Private

    private(set) var recentSentryEventID: String?

    private nonisolated func attachLogsToSentry() {
        // We can assume we are running since this ic only called fron a callback by the SDK
        do {
            let logStore = try LogStore(strategy: .sinceEnd, timeinterval: 60)
            try logStore.getEntries()

            for entry in logStore.entries {
                let breadcrumb = Breadcrumb(
                    level: entry.level.sentryLevel, category: entry.category)
                breadcrumb.timestamp = entry.date
                breadcrumb.message = entry.composedMessage
                SentrySDK.addBreadcrumb(breadcrumb)
            }
        } catch {
            logger.error("Failed to sync logs with crash reporter: \(error.localizedDescription)")
        }
    }
}

extension OSLogType {
    fileprivate var sentryLevel: SentryLevel {
        switch self {
        case .debug: return .debug
        case .default, .info: return .info
        case .error: return .error
        case .fault: return .fatal
        default: return .none
        }
    }
}

extension OSLogEntryLog.Level {
    fileprivate var sentryLevel: SentryLevel {
        switch self {
        case .debug: return .debug
        case .info: return .info
        case .error: return .error
        case .fault: return .fatal
        default: return .none
        }
    }
}

private let logger = Logger(category: "diagnostics")
