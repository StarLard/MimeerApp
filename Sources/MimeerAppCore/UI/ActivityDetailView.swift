//
//  ActivityDetailView.swift
//  MimeerApp
//
//  Created by Caleb Friden on 7/27/23.
//

import MimeerKit
import OSLog
import SwiftData
import SwiftUI

struct ActivityDetailView: View {
    var activity: Activity

    @State private var isDeleteConfirmationDialogPresented = false
    @State private var isActivityEditorPresented = false
    @State private var insightsDateFilter: DateFilter = .today
    @State private var isEventEditorPresented = false
    @State private var eventSelection: Event?
    @State private var eventIDSelection: UUID?
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Environment(\.calendar) private var calendar
    @Environment(\.date) private var date
    @State private var isEditing: Bool = false

    var body: some View {
        listContent
            .overlay {
                if sortedEvents.isEmpty {
                    Text("No Events")
                        .foregroundStyle(.secondary)
                }
            }
            .toolbar {
                #if os(iOS)
                    ToolbarItem(placement: .topBarTrailing) {
                        if !isEditing {
                            menu
                        } else {
                            Button("Done") {
                                withAnimation {
                                    isEditing = false
                                }
                            }
                        }
                    }
                    ToolbarItem(placement: .bottomBar) {
                        createEventButton
                    }
                #elseif os(macOS)
                    ToolbarItem(placement: .primaryAction) {
                        createEventButton
                    }
                #endif
            }
            .onChange(of: eventIDSelection) { oldValue, newValue in
                guard oldValue != newValue else { return }
                if let eventID = newValue {
                    eventSelection = activity.events.first(where: { event in
                        event.id == eventID
                    })
                } else {
                    eventSelection = nil
                }
            }
            .onChange(of: eventSelection) { oldValue, newValue in
                guard oldValue != newValue else { return }
                if newValue != nil {
                    isEventEditorPresented = true
                } else {
                    isEventEditorPresented = false
                }
            }
            .onChange(of: isEventEditorPresented) { oldValue, newValue in
                guard oldValue != newValue else { return }
                if !newValue {
                    eventIDSelection = nil
                }
            }
            .inspector(isPresented: $isEventEditorPresented) {
                if let event = eventSelection {
                    EventEditor(event: event)
                        .interactiveDismissDisabled(false)
                        .presentationDetents([.medium, .large])
                        .presentationBackground(.thinMaterial)
                        .presentationBackgroundInteraction(.enabled)
                }
            }
            .confirmationDialog(
                "Delete Activity", isPresented: $isDeleteConfirmationDialogPresented
            ) {
                Button("Delete", role: .destructive, action: deleteActivity)
                Button("Cancel", role: .cancel) {
                    isDeleteConfirmationDialogPresented = false
                }
            }
            .onInitialAppear {
                insightsDateFilter =
                    DateFilter.allCases.first(where: { filter in
                        switch filter {
                        case .today:
                            return sortedEvents.contains { event in
                                calendar.isDateInToday(event.timestamp)
                            }
                        case .yesterday:
                            return sortedEvents.contains { event in
                                calendar.isDateInYesterday(event.timestamp)
                            }
                        case .week:
                            return sortedEvents.contains { event in
                                calendar.isDate(
                                    date, equalTo: event.timestamp, toGranularity: .weekOfYear)
                            }
                        case .month:
                            return sortedEvents.contains { event in
                                calendar.isDate(
                                    date, equalTo: event.timestamp, toGranularity: .month)
                            }
                        case .all:
                            return true
                        }
                    }) ?? .all
            }
            .navigationTitle(activity.title)
            #if os(iOS)
                .navigationBarTitleDisplayMode(.large)
            #endif
    }

    private var listContent: some View {
        Group {
            if isEditing {
                List {
                    ForEach(sortedEvents) { event in
                        EventRow(event: event)
                    }
                    .onDelete(perform: deleteEvents)
                }
                #if os(iOS)
                    .environment(\.editMode, .constant(EditMode.active))
                #endif
            } else {
                List(selection: $eventIDSelection) {
                    if !activity.note.isEmpty {
                        Section {
                            Text(activity.note)
                        } header: {
                            Text("Note")
                        }
                    }
                    if sortedEvents.count > 1 {
                        insightsSection
                    }
                    eventsSections
                }
            }
        }
    }

    private var insightsSection: some View {
        Section {
            ActivityInsightsSummaryView(
                summary: .init(
                    activity: activity, dateFilter: insightsDateFilter, calendar: calendar, now: date))
        } header: {
            HStack {
                Text("Insights")
                Spacer()
                Picker(selection: $insightsDateFilter) {
                    ForEach(DateFilter.allCases, id: \.self) { filter in
                        Text(filter.title)
                            .textCase(nil)
                    }
                } label: {
                    Label("Filter", systemImage: "line.3.horizontal.decrease.circle")
                }
                .pickerStyle(.menu)
            }
        }
    }

    private var eventsSections: some View {
        ForEach(eventsByDate, id: \.first?.timestamp) { eventsForDate in
            Section {
                ForEach(eventsForDate) { event in
                    EventRow(event: event)
                        .id(event.id)
                        .contextMenu {
                            Button(role: .destructive) {
                                deleteEvent(event)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                }
            } header: {
                if let timestamp = eventsForDate.first?.timestamp {
                    if calendar.isDateInToday(timestamp) {
                        Text("Today")
                    } else if calendar.isDateInYesterday(timestamp) {
                        Text("Yesterday")
                    } else if calendar.isDate(timestamp, equalTo: .now, toGranularity: .weekOfYear) {
                        Text(timestamp, format: .dateTime.weekday(.wide))
                    } else {
                        Text(timestamp, format: .dateTime.day().month().year())
                    }
                }
            }
        }
    }

    private var sortedEvents: [Event] {
        activity.events.sorted(using: SortDescriptor(\Event.timestamp, order: .reverse))
    }

    private var eventsByDate: [[Event]] {
        var eventsByDate: [[Event]] = []
        var eventsForDate: [Event] = []
        var lastDateComponents: DateComponents?
        for event in sortedEvents {
            let dateComponents = calendar.dateComponents(
                [.day, .month, .year], from: event.timestamp)
            if dateComponents == lastDateComponents || lastDateComponents == nil {
                eventsForDate.append(event)
            } else {
                eventsByDate.append(eventsForDate)
                eventsForDate = [event]
            }
            lastDateComponents = dateComponents
        }
        if !eventsForDate.isEmpty {
            eventsByDate.append(eventsForDate)
        }
        return eventsByDate
    }

    private var createEventButton: some View {
        HStack {
            Button(action: createEvent) {
                HStack {
                    Image(systemName: "plus.circle.fill")
                    Text("Log Event")
                }
            }

            Spacer()
        }
    }

    private var menu: some View {
        Menu {
            Button {
                withAnimation {
                    isActivityEditorPresented.toggle()
                }
            } label: {
                Label("Show Info", systemImage: "info.circle")
            }

            #if os(iOS)
                if !sortedEvents.isEmpty {
                    Button {
                        withAnimation {
                            eventSelection = nil
                            isEditing = true
                        }
                    } label: {
                        Label("Edit Events", systemImage: "pencil")
                    }
                }
            #endif

            Button(role: .destructive) {
                isDeleteConfirmationDialogPresented.toggle()
            } label: {
                Label("Delete Activity", systemImage: "trash")
            }

        } label: {
            Label("Activity", systemImage: "ellipsis.circle")
        }
    }

    private func deleteActivity() {
        withAnimation {
            Logger.general.info("Deleting activity with ID: \(activity.id, privacy: .public)")
            modelContext.delete(activity)
            modelContext.syncWidgets()
            dismiss()
        }
    }

    private func deleteEvents(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                Logger.general.info("Deleting \(offsets.count, privacy: .public) events")
                modelContext.delete(sortedEvents[index])
            }
            if !offsets.isEmpty {
                modelContext.syncWidgets()
            }
        }
    }

    private func deleteEvent(_ event: Event) {
        withAnimation {
            if event == eventSelection {
                eventSelection = nil
            }
            Logger.general.info("Deleting event at \(event.timestamp, privacy: .public)")
            modelContext.delete(event)
            modelContext.syncWidgets()
        }
    }

    private func createEvent() {
        Task { await LogEventTip.didLogEventViaDetailView.donate() }

        withAnimation {
            _ = modelContext.insertNewEvent(for: activity)
        }
    }
}

#if DEBUG
    #Preview {
        NavigationStack {
            ActivityDetailView(activity: Mocks.activities[0])
        }
        .modelContainer(.shared)
    }
#endif
