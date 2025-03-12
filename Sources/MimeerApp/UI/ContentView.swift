//
//  ContentView.swift
//  MimeerApp
//
//  Created by Caleb Friden on 7/23/23.
//

import MimeerKit
import OSLog
import SwiftData
import SwiftUI
import TipKit

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: [SortDescriptor(\Activity.displayPriority), SortDescriptor(\Activity.title)])
    private var activities: [Activity]
    #if os(iOS)
        @State private var isSettingsViewPresented = false
    #endif
    @State private var isNewActivityViewPresented = false
    @State private var isActivityEditorPresented = false
    @State private var navigationPath: [Activity] = []
    @State private var isEditing = false
    @State private var preferredCompactColumn: NavigationSplitViewColumn = .sidebar

    let columns = [
        GridItem(.adaptive(minimum: 136, maximum: 256))
    ]

    let navigationSplitViewColumnIdealWidth: CGFloat = {
        #if os(iOS)
            return 280
        #elseif os(macOS)
            return 460
        #endif
    }()

    var body: some View {
        NavigationSplitView(preferredCompactColumn: $preferredCompactColumn) {
            Group {
                if isEditing {
                    activitiesList
                } else {
                    activitiesGallery
                }
            }
            .focusedSceneValue(\.modelContext, modelContext)
            .focusedSceneValue(\.navigationPath, $navigationPath)
            .focusedSceneValue(\.isNewActivityViewPresented, $isNewActivityViewPresented)
            .focusedSceneValue(\.isActivityEditorPresented, $isActivityEditorPresented)
            .navigationTitle("Activities")
            .toolbar {
                #if os(iOS)
                    ToolbarItem(placement: .topBarTrailing) {
                        if !isEditing {
                            if activities.isEmpty {
                                settingsButton
                            } else {
                                menu
                            }
                        } else {
                            Button("Done") {
                                withAnimation {
                                    isEditing = false
                                }
                            }
                        }
                    }

                    if !isEditing {
                        ToolbarItem(placement: .bottomBar) {
                            createActivityButton
                        }
                    }

                #elseif os(macOS)
                    ToolbarItem(placement: .primaryAction) {
                        createActivityButton
                    }
                #endif
            }
        } detail: {
            if let presentedActivity {
                ActivityDetailView(activity: presentedActivity)
                    .focusedSceneValue(\.modelContext, modelContext)
                    .focusedSceneValue(\.navigationPath, $navigationPath)
                    .focusedSceneValue(\.isNewActivityViewPresented, $isNewActivityViewPresented)
                    .focusedSceneValue(\.isActivityEditorPresented, $isActivityEditorPresented)
            } else {
                Text("Nothing Selected")
            }
        }
        .navigationSplitViewColumnWidth(ideal: navigationSplitViewColumnIdealWidth)
        .sheet(isPresented: $isNewActivityViewPresented) {
            #if os(iOS)
                NavigationStack {
                    ActivityEditor(displayPriority: UInt(activities.count))
                }
            #elseif os(macOS)
                ActivityEditor(displayPriority: UInt(activities.count))
                    .fixedSize()
            #endif
        }
        .sheet(isPresented: $isActivityEditorPresented) {
            if let presentedActivity {
                #if os(iOS)
                    NavigationStack {
                        ActivityEditor(existingActivity: presentedActivity)
                    }
                #elseif os(macOS)
                    ActivityEditor(existingActivity: presentedActivity)
                        .fixedSize()
                #endif
            }
        }
        #if os(iOS)
            .sheet(isPresented: $isSettingsViewPresented) {
                SettingsView()
            }
        #endif
        .focusedSceneValue(\.modelContext, modelContext)
        .focusedSceneValue(\.navigationPath, $navigationPath)
        .focusedSceneValue(\.isNewActivityViewPresented, $isNewActivityViewPresented)
        .focusedSceneValue(\.isActivityEditorPresented, $isActivityEditorPresented)
        .onChange(of: navigationPath) { oldValue, newValue in
            preferredCompactColumn = newValue.isEmpty ? .sidebar : .detail
        }
        .onChange(of: preferredCompactColumn) { oldValue, newValue in
            if newValue != oldValue, oldValue == .detail {
                _ = navigationPath.popLast()
            }
        }
    }

    private var presentedActivity: Activity? { navigationPath.last }

    private var tip = LogEventTip()

    private var activitiesList: some View {
        List {
            ForEach(activities) { activity in
                ActivityRow(activity: activity)
            }
            .onMove(perform: moveActivities)
            .onDelete(perform: deleteActivities)
        }
        #if os(iOS)
            .environment(\.editMode, .constant(EditMode.active))
        #endif
    }

    private var activitiesGallery: some View {
        ScrollView {
            TipView(tip)

            LazyVGrid(columns: columns) {
                ForEach(activities) { activity in
                    VStack {
                        ActivityCard(activity: activity)
                    }
                }
            }
        }
        #if os(macOS)
            .contentMargins(.top, 16)
        #endif
        .overlay {
            if activities.isEmpty {
                Text("No Activities")
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.horizontal)
    }

    private var createActivityButton: some View {
        HStack {
            Button(action: createActivity) {
                HStack {
                    Image(systemName: "plus.circle.fill")
                    Text("New Activity")
                }
            }

            Spacer()
        }
    }

    #if os(iOS)
        private var menu: some View {
            Menu {
                Button {
                    withAnimation {
                        isEditing.toggle()
                    }
                } label: {
                    Label("Edit Activities", systemImage: "pencil")
                }

                settingsButton
            } label: {
                Label("Activities", systemImage: "ellipsis.circle")
            }
        }

        private var settingsButton: some View {
            Button {
                withAnimation {
                    isSettingsViewPresented.toggle()
                }
            } label: {
                Label("Settings", systemImage: "gear")
            }
        }
    #endif

    private func createActivity() {
        withAnimation {
            isNewActivityViewPresented.toggle()
        }
    }

    private func moveActivities(from source: IndexSet, to destination: Int) {
        var movedActivities = activities
        movedActivities.move(fromOffsets: source, toOffset: destination)
        // Set new order in reverse to avoid having activitys jump around while updating
        for (index, activity) in movedActivities.enumerated().reversed() {
            activity.displayPriority = UInt(index)
        }
    }

    private func deleteActivities(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                Logger.general.info("Deleting \(offsets.count, privacy: .public) activities")
                modelContext.delete(activities[index])
            }
            if !offsets.isEmpty {
                modelContext.syncWidgets()
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(.shared)
}
