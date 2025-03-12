//
//  TimestampText.swift
//  Lastly
//
//  Created by Caleb Friden on 8/16/23.
//

import SwiftUI

struct TimestampText: View {
    var timestamp: Date

    @Environment(\.calendar) private var calendar
    @Environment(\.locale) private var locale
    @State private var currentTimestamp = Date.now
    private let timer = Timer.publish(every: .minute, on: .current, in: .common).autoconnect()

    private let relativeDateformatter: RelativeDateTimeFormatter = {
        let formatter = RelativeDateTimeFormatter()
        formatter.dateTimeStyle = .named
        return formatter
    }()

    private var text: Text {
        if timestamp.timeIntervalSince(currentTimestamp) > -.minute {
            Text("Just now")
        } else if timestamp.timeIntervalSince(currentTimestamp) > (-4 * .hour) {
            Text(timestamp, formatter: relativeDateformatter)
        } else if calendar.isDateInToday(timestamp) {
            Text(timestamp, style: .time)
        } else if calendar.isDateInYesterday(timestamp) {
            Text("Yesterday \(timestamp.formatted(date: .omitted, time: .shortened))")
        } else if calendar.isDate(timestamp, equalTo: .now, toGranularity: .weekOfYear) {
            Text(timestamp, format: .dateTime.weekday().hour().minute())
        } else if calendar.isDate(timestamp, equalTo: .now, toGranularity: .year) {
            Text(timestamp, format: .dateTime.month().day().hour().minute())
        } else {
            Text(timestamp, format: .dateTime)
        }
    }

    var body: some View {
        text.onReceive(timer) { _ in
            currentTimestamp = .now
        }
        .onAppear {
            currentTimestamp = .now
        }
        .onChange(of: locale, initial: true) { _, newValue in
            relativeDateformatter.locale = newValue
        }
    }
}

#Preview {
    VStack {
        TimestampText(timestamp: .now)
        TimestampText(timestamp: .init(timeIntervalSinceNow: -2 * .hour))
        TimestampText(timestamp: .init(timeIntervalSinceNow: -12 * .hour))
        TimestampText(timestamp: .init(timeIntervalSinceNow: -24 * .hour))
        TimestampText(timestamp: .init(timeIntervalSinceNow: -2 * .day))
        TimestampText(timestamp: .init(timeIntervalSinceNow: -30 * .day))
        TimestampText(timestamp: .init(timeIntervalSinceNow: -500 * .day))
    }
}
