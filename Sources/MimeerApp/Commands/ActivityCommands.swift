//
//  ActivityCommands.swift
//  MimeerApp
//
//  Created by Caleb Friden on 9/29/23.
//

import Foundation
import MimeerKit
import SwiftData
import SwiftUI

struct ActivityCommands: Commands {
    @FocusedBinding(\.navigationPath) var navigationPath: [Activity]?
    @FocusedValue(\.modelContext) var modelContext: ModelContext?
    @FocusedBinding(\.isNewActivityViewPresented) var isNewActivityViewPresented: Bool?
    @FocusedBinding(\.isActivityEditorPresented) var isActivityEditorPresented: Bool?

    var body: some Commands {
        CommandGroup(before: .newItem) {
            if activity != nil {
                Button("Log Event", action: createEvent)
                    .keyboardShortcut("n", modifiers: [.shift, .command])
            } else {
                Button("New Activity", action: createActivity)
                    .keyboardShortcut("n", modifiers: [.shift, .command])
            }
        }

        if activity != nil {
            CommandGroup(before: .toolbar) {
                Button("Show Info", action: showActivityEditor)
                    .keyboardShortcut("h", modifiers: [.shift, .command])
            }
        }
    }

    private func createEvent() {
        guard let activity = activity.assertHasValue(),
            let modelContext = modelContext.assertHasValue()
        else { return }

        withAnimation {
            _ = modelContext.insertNewEvent(for: activity)
        }
    }

    private func createActivity() {
        withAnimation {
            isNewActivityViewPresented = true
        }
    }

    private func showActivityEditor() {
        withAnimation {
            isActivityEditorPresented = true
        }
    }

    private var activity: Activity? { navigationPath?.last }
}

struct NavigationPathKey: FocusedValueKey {
    typealias Value = Binding<[Activity]>
}

struct IsNewActivityViewPresentedKey: FocusedValueKey {
    typealias Value = Binding<Bool>
}

struct IsActivityEditorPresented: FocusedValueKey {
    typealias Value = Binding<Bool>
}

extension FocusedValues {
    var navigationPath: NavigationPathKey.Value? {
        get { self[NavigationPathKey.self] }
        set { self[NavigationPathKey.self] = newValue }
    }

    var isNewActivityViewPresented: IsNewActivityViewPresentedKey.Value? {
        get { self[IsNewActivityViewPresentedKey.self] }
        set { self[IsNewActivityViewPresentedKey.self] = newValue }
    }

    var isActivityEditorPresented: IsActivityEditorPresented.Value? {
        get { self[IsActivityEditorPresented.self] }
        set { self[IsActivityEditorPresented.self] = newValue }
    }
}
