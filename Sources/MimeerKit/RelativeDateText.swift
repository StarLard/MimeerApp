//
//  RelativeDateText.swift
//  MimeerKit
//
//  Created by Caleb Friden on 8/20/23.
//

import Combine
import StarLardKit
import SwiftUI

/// A view that displays a date relative to the current date with formatting that adapts to the interval.
public struct RelativeDateText: View {
    /// The date to compare
    var date: Date

    /// The current date that should be compared against
    @State var autoupdatingCurrentDate: Date

    public init(date: Date, autoupdate: Bool = true) {
        self.date = date
        self._autoupdatingCurrentDate = State(initialValue: .current)
        let publisher:
            AnyPublisher<
                Publishers.Autoconnect<Timer.TimerPublisher>.Output,
                Publishers.Autoconnect<Timer.TimerPublisher>.Failure
            >
        if autoupdate {
            publisher =
                Timer
                .publish(every: .minute, on: .current, in: .common)
                .autoconnect()
                .eraseToAnyPublisher()
        } else {
            publisher = Empty(completeImmediately: false).eraseToAnyPublisher()
        }
        self._timerPublisher = State(initialValue: publisher)
    }

    @Environment(\.date) private var currentDate
    @Environment(\.calendar) private var calendar
    @Environment(\.locale) private var locale
    @State private var timerPublisher:
        AnyPublisher<
            Publishers.Autoconnect<Timer.TimerPublisher>.Output, Publishers.Autoconnect<Timer.TimerPublisher>.Failure
        >

    private let relativeDateformatter: RelativeDateTimeFormatter = {
        let formatter = RelativeDateTimeFormatter()
        formatter.dateTimeStyle = .named
        formatter.formattingContext = .listItem
        formatter.unitsStyle = .abbreviated
        return formatter
    }()

    public var body: some View {
        Text(localizedText)
            .modify(whenUnwrapped: relativeDateNumericComponent) { view, numericComponent in
                view.contentTransition(.numericText(value: numericComponent))
            }
            .onChange(of: locale, initial: true) { _, newValue in
                relativeDateformatter.locale = newValue
            }
            .onChange(of: calendar, initial: true) { _, newValue in
                relativeDateformatter.calendar = newValue
            }
            .onChange(of: currentDate, initial: true) { _, newValue in
                autoupdatingCurrentDate = newValue
            }
            .onReceive(timerPublisher) { _ in
                autoupdatingCurrentDate = .current
            }
    }

    private var localizedText: String {
        if date.timeIntervalSince(autoupdatingCurrentDate) > -.minute {
            return relativeDateformatter.localizedString(
                for: autoupdatingCurrentDate, relativeTo: autoupdatingCurrentDate)
        } else if date.timeIntervalSince(autoupdatingCurrentDate) > (-3 * .hour) {
            return relativeDateformatter.localizedString(for: date, relativeTo: autoupdatingCurrentDate)
        } else if calendar.isDate(date, inSameDayAs: autoupdatingCurrentDate) {
            return date.formatted(date: .omitted, time: .shortened)
        } else if isDateInYesterday {
            return String(localized: "Yesterday \(date.formatted(date: .omitted, time: .shortened))")
        } else if calendar.isDate(date, equalTo: autoupdatingCurrentDate, toGranularity: .weekOfYear) {
            return date.formatted(Date.FormatStyle.dateTime.weekday().hour().minute())
        } else if calendar.isDate(date, equalTo: autoupdatingCurrentDate, toGranularity: .year) {
            return date.formatted(Date.FormatStyle.dateTime.month().day().hour().minute())
        } else {
            return date.formatted(Date.FormatStyle.dateTime)
        }
    }

    private var yesterday: Date? {
        calendar.date(byAdding: .day, value: -1, to: autoupdatingCurrentDate)
    }

    private var isDateInYesterday: Bool {
        yesterday.map { calendar.isDate(date, inSameDayAs: $0) } ?? false
    }

    private var localizedRelativeDate: String {
        relativeDateformatter.localizedString(for: date, relativeTo: autoupdatingCurrentDate)
    }

    private var relativeDateNumericComponent: Double? {
        let numericComponents =
            localizedRelativeDate
            .split(separator: " ")
            .map {
                $0.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
            }
            .compactMap(Double.init(_:))
        assert(numericComponents.count <= 1)
        return numericComponents.first
    }
}

#Preview {
    VStack {
        RelativeDateText(date: .now)
        RelativeDateText(date: .init(timeIntervalSinceNow: -5 * .minute))
        RelativeDateText(date: .init(timeIntervalSinceNow: -2.5 * .hour))
        RelativeDateText(date: .init(timeIntervalSinceNow: -4 * .hour))
        RelativeDateText(date: .init(timeIntervalSinceNow: -24 * .hour))
        RelativeDateText(date: .init(timeIntervalSinceNow: -2 * .day))
        RelativeDateText(date: .init(timeIntervalSinceNow: -30 * .day))
        RelativeDateText(date: .init(timeIntervalSinceNow: -500 * .day))
    }
}
