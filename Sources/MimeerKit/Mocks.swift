//
//  Mocks.swift
//  MimeerKit
//
//  Created by Caleb Friden on 7/24/23.
//

import Foundation

#if DEBUG
    public enum Mocks {
        public static var activities: [Activity] {
            var activities: [Activity] = []
            let icons: [SFSymbol] = [.globeDeskFill, .sparkles, .moonStarsFill, .gamecontrollerFill, .leafFill]
            let notes = [
                "", "", "I did it again", "",
                "Thus I embarked on what would soon become the greatest journey of my life",
            ]

            for i in 0..<numberOfActivitys {
                let activity = Activity(
                    title: Array(repeating: "Activity \(i)", count: i + 1).joined(separator: " "),
                    icon: icons[i],
                    color: .init(red: .random(in: 0..<1), green: .random(in: 0..<1), blue: .random(in: 0..<1)),
                    note: notes[i],
                    displayPriority: UInt(i))
                activities.append(activity)
            }
            return activities
        }

        public static var events: [Event] {
            var events: [Event] = []

            for i in 0..<40 {
                let event = Event(timestamp: Date(timeIntervalSinceNow: -.hour * pow(Double(i), 1.5)))
                if i % 4 == 0 {
                    event.duration = Double(i) * .minute
                }
                if i % 8 == 0 {
                    event.note = Array(repeating: "All work and no play makes Jack a dull boy.", count: i / 8).joined(
                        separator: " ")
                }
                events.append(event)
            }
            return events
        }
    }

    private let numberOfActivitys = 5
#endif
