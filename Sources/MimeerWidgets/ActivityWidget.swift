//
//  ActivityWidget.swift
//  Mimeer WidgetsExtension
//
//  Created by Caleb Friden on 8/21/23.
//

import MimeerKit
import SwiftData
import SwiftUI
import WidgetKit

public struct ActivityWidget: Widget {
    public init() {}

    let kind: String = "Activity Widget"

    var families: [WidgetFamily] {
        #if os(iOS)
            return [.accessoryRectangular, .systemSmall, .systemMedium, .systemLarge, .systemExtraLarge]
        #else
            return [.systemSmall, .systemMedium, .systemLarge]
        #endif
    }

    @MainActor
    public var body: some WidgetConfiguration {
        AppIntentConfiguration(
            kind: kind,
            intent: ActivityWidgetIntent.self,
            provider: ActivitySnapshotTimelineProvider()
        ) { entry in
            ActivityWidgetView(entry: entry)
        }
        .supportedFamilies(families)

    }
}

struct ActivityWidgetView: View {
    var entry: ActivitySnapshotTimelineProvider.Entry
    @Environment(\.widgetFamily) var widgetFamily

    var body: some View {
        if let snapshot = entry.snapshot {
            ActivitySnapshotWidgetView(snapshot: snapshot)
        } else {
            VStack(spacing: 8) {
                Text("Select Activity")
                    .foregroundStyle(.secondary)

                #if os(iOS)
                    if widgetFamily != .accessoryRectangular {
                        Text("Edit widget to select")
                            .font(.subheadline)
                            .foregroundStyle(.tertiary)
                    }
                #endif
            }
            .multilineTextAlignment(.center)
            .containerBackground(.fill, for: .widget)
        }
    }
}

struct ActivitySnapshotWidgetView: View {
    var snapshot: ActivitySnapshot

    var body: some View {
        Button(intent: addEventIntent) {
            switch widgetFamily {
            case .accessoryRectangular, .accessoryCircular, .accessoryInline, .systemSmall:
                activityCard
            case .systemMedium:
                HStack(alignment: .top) {
                    activityCard
                    eventList(events: snapshot.recentEvents.prefix(3), alignment: .trailing)
                }
            case .systemLarge, .systemExtraLarge:
                GeometryReader { proxy in
                    VStack(alignment: .leading) {
                        activityCard
                            .frame(maxHeight: proxy.size.height / 2)

                        Divider()
                            .overlay(.white)

                        if snapshot.recentEvents.isEmpty {
                            Text("No Events")
                                .font(.subheadline)
                                .foregroundStyle(.white)
                        }

                        HStack(alignment: .top) {
                            eventList(events: snapshot.recentEvents.prefix(4), alignment: .leading)
                            Spacer()
                            eventList(events: snapshot.recentEvents.dropFirst(4).prefix(4), alignment: .leading)
                            Spacer()

                            if widgetFamily == .systemExtraLarge {
                                eventList(events: snapshot.recentEvents.dropFirst(8).prefix(4), alignment: .leading)
                                Spacer()

                                eventList(
                                    events: snapshot.recentEvents.dropFirst(12).prefix(4), alignment: .leading)
                                Spacer()
                            }
                        }
                    }
                }
            @unknown default:
                activityCard
            }
        }
        .invalidatableContent()
        .buttonStyle(.plain)
        .containerBackground(Color(snapshot.color), for: .widget)
    }

    @Environment(\.widgetRenderingMode) private var widgetRenderingMode
    @Environment(\.widgetFamily) private var widgetFamily
    @Environment(\.calendar) private var calendar

    private var activityCard: some View {
        ActivityCardView(
            activityTitle: snapshot.title,
            activityLastEvent: displayLastEvent ? snapshot.lastEvent : nil,
            activityColor: Color(snapshot.color),
            activityIcon: snapshot.icon,
            isSelected: false,
            autoupdateRelativeDateForLastEvent: false,
            animationPhase: .idle,
            willBeDisplayedOnTransparentBackground: willBeDisplayedOnTransparentBackground,
            sizeClass: cardSizeClass,
            successFeedbackTrigger: true
        )
    }

    private func eventList(events: ArraySlice<Date>, alignment: HorizontalAlignment) -> some View {
        VStack(alignment: alignment, spacing: 8) {
            ForEach(events, id: \.timeIntervalSinceReferenceDate) { eventDate in
                VStack(alignment: alignment) {
                    Group {
                        if calendar.isDateInToday(eventDate) {
                            Text("Today")
                        } else if calendar.isDateInYesterday(eventDate) {
                            Text("Yesterday")
                        } else if calendar.isDate(eventDate, equalTo: .now, toGranularity: .weekOfYear) {
                            Text(eventDate, format: .dateTime.weekday())
                        } else {
                            Text(eventDate, format: Date.FormatStyle(date: .abbreviated, time: .omitted))
                        }
                    }.font(.subheadline)

                    Text(eventDate, format: Date.FormatStyle(date: .omitted, time: .shortened))
                        .font(.headline)
                }
                .foregroundStyle(.white)
                .lineLimit(1)
            }
        }
    }

    var displayLastEvent: Bool {
        switch widgetFamily {
        case .accessoryRectangular, .accessoryCircular, .accessoryInline, .systemSmall:
            return true
        case .systemMedium, .systemLarge, .systemExtraLarge:
            return false
        @unknown default:
            return true
        }
    }

    @MainActor
    private var addEventIntent: AddEvent {
        let intent = AddEvent()
        intent.activityEntity = ActivityEntity(
            id: snapshot.id, title: snapshot.title, lastEvent: snapshot.lastEvent)
        return intent
    }

    private var willBeDisplayedOnTransparentBackground: Bool {
        switch widgetRenderingMode {
        case .fullColor:
            return false
        case .vibrant:
            return true
        default:
            return false
        }
    }

    private var cardSizeClass: ActivityCardView.SizeClass {
        switch widgetFamily {
        case .accessoryRectangular, .accessoryCircular, .accessoryInline:
            return .compact
        case .systemSmall, .systemMedium:
            return .narrow
        case .systemLarge, .systemExtraLarge:
            return .default
        @unknown default:
            return .default
        }
    }
}

#if DEBUG
    extension ActivitySnapshot {
        fileprivate init(date: Date, activity: Activity) {
            self.init(
                date: date, activity: activity,
                recentEvents: activity.events.sorted(using: SortDescriptor(\.timestamp, order: .reverse)))
        }
    }

    #Preview("systemSmall", as: .systemSmall) {
        ActivityWidget()
    } timeline: {
        ActivityWidgetEntry(date: .now)
        ActivityWidgetEntry(
            date: .now, snapshot: ActivitySnapshot(date: .now, activity: Mocks.activities[0]))
        ActivityWidgetEntry(
            date: .now, snapshot: ActivitySnapshot(date: .now, activity: Mocks.activities[1]))
        ActivityWidgetEntry(
            date: .now, snapshot: ActivitySnapshot(date: .now, activity: Mocks.activities[2]))
        ActivityWidgetEntry(
            date: .now, snapshot: ActivitySnapshot(date: .now, activity: Mocks.activities[3]))
        ActivityWidgetEntry(
            date: .now, snapshot: ActivitySnapshot(date: .now, activity: Mocks.activities[4]))
    }

    #Preview("systemMedium", as: .systemMedium) {
        ActivityWidget()
    } timeline: {
        ActivityWidgetEntry(date: .now)
        ActivityWidgetEntry(
            date: .now, snapshot: ActivitySnapshot(date: .now, activity: Mocks.activities[0]))
        ActivityWidgetEntry(
            date: .now, snapshot: ActivitySnapshot(date: .now, activity: Mocks.activities[1]))
        ActivityWidgetEntry(
            date: .now, snapshot: ActivitySnapshot(date: .now, activity: Mocks.activities[2]))
        ActivityWidgetEntry(
            date: .now, snapshot: ActivitySnapshot(date: .now, activity: Mocks.activities[3]))
        ActivityWidgetEntry(
            date: .now, snapshot: ActivitySnapshot(date: .now, activity: Mocks.activities[4]))
    }

    #Preview("systemLarge", as: .systemLarge) {
        ActivityWidget()
    } timeline: {
        ActivityWidgetEntry(date: .now)
        ActivityWidgetEntry(
            date: .now, snapshot: ActivitySnapshot(date: .now, activity: Mocks.activities[0]))
        ActivityWidgetEntry(
            date: .now, snapshot: ActivitySnapshot(date: .now, activity: Mocks.activities[1]))
        ActivityWidgetEntry(
            date: .now, snapshot: ActivitySnapshot(date: .now, activity: Mocks.activities[2]))
        ActivityWidgetEntry(
            date: .now, snapshot: ActivitySnapshot(date: .now, activity: Mocks.activities[3]))
        ActivityWidgetEntry(
            date: .now, snapshot: ActivitySnapshot(date: .now, activity: Mocks.activities[4]))
    }

    #if os(iOS)
        #Preview("systemExtraLarge", as: .systemExtraLarge) {
            ActivityWidget()
        } timeline: {
            ActivityWidgetEntry(date: .now)
            ActivityWidgetEntry(
                date: .now, snapshot: ActivitySnapshot(date: .now, activity: Mocks.activities[0]))
            ActivityWidgetEntry(
                date: .now, snapshot: ActivitySnapshot(date: .now, activity: Mocks.activities[1]))
            ActivityWidgetEntry(
                date: .now, snapshot: ActivitySnapshot(date: .now, activity: Mocks.activities[2]))
            ActivityWidgetEntry(
                date: .now, snapshot: ActivitySnapshot(date: .now, activity: Mocks.activities[3]))
            ActivityWidgetEntry(
                date: .now, snapshot: ActivitySnapshot(date: .now, activity: Mocks.activities[4]))
        }

        #Preview("accessoryRectangular", as: .accessoryRectangular) {
            ActivityWidget()
        } timeline: {
            ActivityWidgetEntry(date: .now)
            ActivityWidgetEntry(
                date: .now, snapshot: ActivitySnapshot(date: .now, activity: Mocks.activities[0]))
            ActivityWidgetEntry(
                date: .now, snapshot: ActivitySnapshot(date: .now, activity: Mocks.activities[1]))
            ActivityWidgetEntry(
                date: .now, snapshot: ActivitySnapshot(date: .now, activity: Mocks.activities[2]))
            ActivityWidgetEntry(
                date: .now, snapshot: ActivitySnapshot(date: .now, activity: Mocks.activities[3]))
            ActivityWidgetEntry(
                date: .now, snapshot: ActivitySnapshot(date: .now, activity: Mocks.activities[4]))
        }
    #endif

#endif
