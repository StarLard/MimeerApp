//
//  ModelContextObserver.swift
//  MimeerApp
//
//  Created by Caleb Friden on 8/17/23.
//

import Combine
import Foundation
import OSLog
import SwiftData

@MainActor
final class ModelContextObserver {
    static let shared = ModelContextObserver()

    func observe(context: ModelContext) {
        notificationCenter
            .publisher(for: ModelContext.willSave, object: context)
            .sink { [weak self] notification in
                guard let self else { return }
                handleNotification(notification)
            }
            .store(in: &subscriptions)

        notificationCenter
            .publisher(for: ModelContext.didSave, object: context)
            .sink { [weak self] notification in
                guard let self else { return }
                handleNotification(notification)
            }
            .store(in: &subscriptions)
    }

    private var subscriptions: Set<AnyCancellable> = []
    private let notificationCenter: NotificationCenter = .default
    private let logger: Logger = .general

    private func handleNotification(_ notification: Notification) {
        let adjective: String
        switch notification.name {
        case ModelContext.willSave:
            adjective = "will"
        case ModelContext.didSave:
            adjective = "did"
        default:
            adjective = "may"
        }
        if let deletedIdentifiers = notification.userInfo?[
            ModelContext.NotificationKey.deletedIdentifiers] as? Set<PersistentIdentifier>
        {
            logger.log(
                "Model context \(adjective, privacy: .public) delete models: \(deletedIdentifiers, privacy: .private)"
            )
        }
        if let insertedIdentifiers = notification.userInfo?[
            ModelContext.NotificationKey.insertedIdentifiers] as? Set<PersistentIdentifier>
        {
            logger.log(
                "Model context \(adjective, privacy: .public) insert models: \(insertedIdentifiers, privacy: .private)"
            )
        }
        if let updatedIdentifiers = notification.userInfo?[
            ModelContext.NotificationKey.updatedIdentifiers] as? Set<PersistentIdentifier>
        {
            logger.log(
                "Model context \(adjective, privacy: .public) update models: \(updatedIdentifiers, privacy: .private)"
            )
        }
    }
}
