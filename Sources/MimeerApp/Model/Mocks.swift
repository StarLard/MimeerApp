//
//  Mocks.swift
//  Lastly
//
//  Created by Caleb Friden on 7/24/23.
//

import Foundation
import MimeerKit

#if DEBUG
    extension Mocks {
        nonisolated(unsafe) static let taskItems: [TaskItem] = {
            var items: [TaskItem] = []
            let icons: [SFSymbol] = [.globeDeskFill, .sparkles, .moonStarsFill, .gamecontrollerFill, .leafFill]
            let notes = [
                "", "", "I did it again", "",
                "Thus I embarked on what would soon become the greatest journey of my life",
            ]

            for i in 0..<numberOfTaskItems {
                let item = TaskItem(
                    title: Array(repeating: "Item \(i)", count: i + 1).joined(separator: " "),
                    icon: icons[i],
                    color: .init(red: .random(in: 0..<1), green: .random(in: 0..<1), blue: .random(in: 0..<1)),
                    note: notes[i],
                    displayPriority: UInt(i))
                items.append(item)
            }
            return items
        }()

        nonisolated(unsafe) static let taskItemEvents: [TaskItemEvent] = {
            var events: [TaskItemEvent] = []

            for i in 0..<20 {
                let event = TaskItemEvent(timestamp: Date(timeIntervalSinceNow: -.hour * pow(Double(i), 1.5)))
                events.append(event)
            }
            return events
        }()

    }

    private let numberOfTaskItems = 5
#endif
