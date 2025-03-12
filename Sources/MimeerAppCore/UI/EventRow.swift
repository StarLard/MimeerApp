//
//  EventRow.swift
//  MimeerApp
//
//  Created by Caleb Friden on 8/16/23.
//

import MimeerKit
import OSLog
import SwiftData
import SwiftUI

struct EventRow: View {
    var event: Event

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(event.timestamp, format: Date.FormatStyle(date: .omitted, time: .shortened))
                Spacer()
                if let duration = event.duration {
                    Text(
                        event.timestamp..<Date(timeInterval: duration, since: event.timestamp),
                        format: durationStyle
                    )
                    .foregroundStyle(.secondary)
                }
            }

            if !event.note.isEmpty {
                Text(event.note)
                    .font(.body.italic())
                    .foregroundStyle(.secondary)
            }
        }
    }

    private var durationStyle: Date.ComponentsFormatStyle {
        var style = Date.ComponentsFormatStyle.timeDuration
        style.style = .narrow
        return style
    }
}

#if DEBUG
    struct EventRowPreviewContainer: View {

        var body: some View {
            NavigationStack {
                List {
                    ForEach(Mocks.events) { event in
                        EventRow(event: event)
                    }
                }
            }
        }
    }

    #Preview {
        EventRowPreviewContainer()
            .modelContainer(.shared)
    }
#endif
