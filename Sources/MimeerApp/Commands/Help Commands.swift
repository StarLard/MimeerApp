//
//  Help Commands.swift
//  MimeerApp
//
//  Created by Caleb Friden on 9/29/23.
//

import Foundation
import SwiftUI

struct HelpCommands: Commands {
    @Environment(\.openWindow) var openWindow

    var body: some Commands {
        CommandGroup(replacing: .help) {
            Link("Support", destination: AppInfo.supportURL)
            Button("Send Feedback", action: showUserFeedback)
        }
    }

    private func showUserFeedback() {
        withAnimation {
            openWindow(id: "user-feedback")
        }
    }
}
