//
//  LogEventTip.swift
//  MimeerApp
//
//  Created by Caleb Friden on 9/12/23.
//

import SwiftUI
import TipKit

struct LogEventTip: Tip {
    /// Defines the user interaction tracked by the top.
    static let didLogEventViaDetailView = Event(id: "didLogEventViaDetailView")

    var rules: [Rule] {
        [
            #Rule(Self.didLogEventViaDetailView) {
                $0.donations.count >= 3
            }
        ]
    }

    var options: [Option] {
        Tips.MaxDisplayCount(2)
    }

    var title: Text {
        Text("Quickly Log an Event")
    }

    var message: Text? {
        #if os(iOS)
            Text("Press and hold an activity to log an event.")
        #elseif os(macOS)
            Text("Right click an activity to log an event.")
        #endif
    }

    var image: Image? {
        Image(systemName: "plus.circle")
    }
}
