//
//  EventEditor.swift
//  MimeerApp
//
//  Created by Caleb Friden on 9/1/23.
//

import MimeerKit
import OSLog
import StarLardKit
import SwiftData
import SwiftUI

struct EventEditor: View {
    @Bindable var event: Event

    var body: some View {
        Form {
            DatePicker("Time", selection: $event.timestamp)

            VStack(alignment: .leading) {
                Toggle("Duration", isOn: $isDurationEnabled)
                    .transaction { transaction in
                        transaction.animation = .none
                    }

                if isDurationEnabled {
                    #if os(iOS)
                        Divider()
                    #endif
                    #warning(
                        "macOS has bug where switching between two events with populated durations doesn't update the duration picker values."
                    )
                    TimeIntervalPicker($duration)
                }
            }

            #if os(iOS)
                Section("Note") {
                    noteField
                }
            #elseif os(macOS)
                noteField
            #endif
        }
        #if os(iOS)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        withAnimation {
                            dismiss()
                        }
                    }
                }
            }
            .navigationTitle("Edit Event")
            .navigationBarTitleDisplayMode(.inline)
        #endif
        .onChange(of: event, initial: true) { _, newValue in
            if newValue.duration != nil {
                if !isDurationEnabled {
                    isDurationEnabled = true
                }
            } else {
                if isDurationEnabled {
                    isDurationEnabled = false
                }
            }
        }
        .onChange(of: isDurationEnabled) { oldValue, newValue in
            guard oldValue != newValue else { return }
            duration = newValue ? (event.duration ?? 0) : 0
        }
        .onChange(of: duration) { oldValue, newValue in
            guard oldValue != newValue else { return }
            event.duration = newValue == 0 ? nil : newValue
        }
    }

    private var noteField: some View {
        TextField("Note", text: $event.note, prompt: Text("Add a note"))
    }

    @Environment(\.dismiss) private var dismiss
    @State private var duration: TimeInterval = 0
    @State private var isDurationEnabled = false
}

#if DEBUG
    #Preview {
        NavigationStack {
            EventEditor(event: Mocks.events[0])
        }
        .modelContainer(.shared)
    }
#endif
