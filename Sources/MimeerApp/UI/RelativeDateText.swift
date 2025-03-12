//
//  RelativeDateText.swift
//  Lastly
//
//  Created by Caleb Friden on 8/20/23.
//

import SwiftUI

/// A view that displays a date relative to the current date with formatting that adapts to the interval.
struct RelativeDateText: View {
    /// The date to compare
    var date: Date

    /// The current date that should be compared against
    var currentDate: Date = .now

    @Environment(\.calendar) private var calendar
    @Environment(\.locale) private var locale

    private let relativeDateformatter: RelativeDateTimeFormatter = {
        let formatter = RelativeDateTimeFormatter()
        formatter.dateTimeStyle = .named
        return formatter
    }()

    private var text: Text {
        if date.timeIntervalSince(currentDate) > -.minute {
            Text("Just now")
        } else if date.timeIntervalSince(currentDate) > (-4 * .hour) {
            Text(date, formatter: relativeDateformatter)
        } else if calendar.isDate(date, inSameDayAs: currentDate) {
            Text(date, style: .time)
        } else if isDateInYesterday {
            Text("Yesterday \(date.formatted(date: .omitted, time: .shortened))")
        } else if calendar.isDate(date, equalTo: currentDate, toGranularity: .weekOfYear) {
            Text(date, format: .dateTime.weekday().hour().minute())
        } else if calendar.isDate(date, equalTo: currentDate, toGranularity: .year) {
            Text(date, format: .dateTime.month().day().hour().minute())
        } else {
            Text(date, format: .dateTime)
        }
    }

    var body: some View {
        text
            .onChange(of: locale, initial: true) { _, newValue in
                relativeDateformatter.locale = newValue
            }
    }

    private var isDateInYesterday: Bool {
        calendar.date(byAdding: .day, value: -1, to: currentDate).map { calendar.isDate(date, inSameDayAs: $0) }
            ?? false
    }
}

#Preview {
    VStack {
        RelativeDateText(date: .now)
        RelativeDateText(date: .init(timeIntervalSinceNow: -2 * .hour))
        RelativeDateText(date: .init(timeIntervalSinceNow: -12 * .hour))
        RelativeDateText(date: .init(timeIntervalSinceNow: -24 * .hour))
        RelativeDateText(date: .init(timeIntervalSinceNow: -2 * .day))
        RelativeDateText(date: .init(timeIntervalSinceNow: -30 * .day))
        RelativeDateText(date: .init(timeIntervalSinceNow: -500 * .day))
    }
}
