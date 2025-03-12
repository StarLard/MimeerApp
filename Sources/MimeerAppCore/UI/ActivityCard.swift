//
//  ActivityCard.swift
//  MimeerApp
//
//  Created by Caleb Friden on 7/27/23.
//

import MimeerKit
import OSLog
import SwiftData
import SwiftUI

struct ActivityCard: View {
    typealias AnimationPhase = ActivityCardView.AnimationPhase

    var activity: Activity
    var tip = LogEventTip()

    var body: some View {
        Group {
            #if os(iOS)
                ActivityCardView(
                    activity: activity,
                    isSelected: isSelected,
                    autoupdateRelativeDateForLastEvent: true,
                    animationPhase: animationPhase,
                    successFeedbackTrigger: successFeedbackTrigger
                )
            #elseif os(macOS)
                PhaseAnimator(AnimationPhase.allCases, trigger: animationTrigger) { phase in
                    ActivityCardView(
                        activity: activity,
                        isSelected: isSelected,
                        autoupdateRelativeDateForLastEvent: true,
                        animationPhase: phase,
                        successFeedbackTrigger: successFeedbackTrigger
                    )
                } animation: { phase in
                    return .spring(duration: phase.duration)
                }
            #endif
        }
        .padding()
        .background(isSelected ? .white : Color(activity.color))
        .aspectRatio(4 / 3, contentMode: .fit)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay {
            if isSelected {
                RoundedRectangle(cornerRadius: 16)
                    .strokeBorder(Color(activity.color), lineWidth: 2)
            }
        }
        .id(activity)
        .onTapGesture {
            if navigationPath?.last != activity {
                navigationPath = [activity]
            }
        }
        #if os(iOS)
            .gesture(phasedLongPressGesture)
        #elseif os(macOS)
            .contextMenu {
                Button(action: addEvent) {
                    Label("Log Event", systemImage: "plus.circle")
                }

                Button(role: .destructive) {
                    isDeleteConfirmationDialogPresented.toggle()
                } label: {
                    Label("Delete Activity", systemImage: "trash")
                }

                Button {
                    withAnimation {
                        navigationPath = [activity]
                        isActivityEditorPresented = true
                    }
                } label: {
                    Label("Show Info", systemImage: "info.circle")
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
        #endif
    }

    private var isSelected: Bool { navigationPath?.last == activity }
    @FocusedBinding(\.navigationPath) var navigationPath: [Activity]?
    @FocusedBinding(\.isActivityEditorPresented) var isActivityEditorPresented: Bool?
    @Environment(\.modelContext) private var modelContext
    @State private var successFeedbackTrigger: Bool = false
    #if os(iOS)
        @State private var animationPhase: ActivityCardView.AnimationPhase = .idle
        private let longPressGestureInitialMinimumDuration: TimeInterval = 0.5
        private let longPressGestureAddEventPhaseDuration: TimeInterval = 0.6

        private var phasedLongPressGesture: some Gesture {
            longPressGesturePhaseThree
                .simultaneously(with: longPressGestureAddEvent)
                .simultaneously(with: longPressGesturePhaseFour)
                .simultaneously(with: longPressGesturePhaseThree)
                .simultaneously(with: longPressGesturePhaseTwo)
                .simultaneously(with: longPressGesturePhaseOne)
                .simultaneously(with: dragGesture)
        }

        private var longPressGesturePhaseOne: some Gesture {
            LongPressGesture(minimumDuration: longPressGestureInitialMinimumDuration)
                .onEnded { finished in
                    if finished {
                        animate(to: .hidingDetails)
                    }
                }
        }

        private var longPressGesturePhaseTwo: some Gesture {
            LongPressGesture(
                minimumDuration: [
                    AnimationPhase.hidingDetails
                ].map(\.duration).reduce(into: longPressGestureInitialMinimumDuration, +=)
            )
            .onEnded { finished in
                if finished {
                    animate(to: .expandingIcon)
                }
            }
        }

        private var longPressGesturePhaseThree: some Gesture {
            LongPressGesture(
                minimumDuration: [
                    AnimationPhase.hidingDetails,
                    .expandingIcon,
                ].map(\.duration).reduce(into: longPressGestureInitialMinimumDuration, +=)
            ).onEnded { finished in
                if finished {
                    animate(to: .replacingIcon)
                }
            }
        }

        private var longPressGestureAddEvent: some Gesture {
            LongPressGesture(
                minimumDuration: [
                    AnimationPhase.hidingDetails,
                    .expandingIcon,
                    .replacingIcon,
                ].map(\.duration)
                    .reduce(
                        into: longPressGestureInitialMinimumDuration + 0.2,
                        +=
                    )
            ).onEnded { finished in
                if finished {
                    addEvent()
                }
            }
        }

        private var longPressGesturePhaseFour: some Gesture {
            LongPressGesture(
                minimumDuration: [
                    AnimationPhase.hidingDetails,
                    .expandingIcon,
                    .replacingIcon,
                ].map(\.duration)
                    .reduce(
                        into: longPressGestureInitialMinimumDuration + 0.8,
                        +=
                    )
            ).onEnded { finished in
                if finished {
                    animate(to: .showingDetails) {
                        animate(to: .idle)
                    }
                }
            }
        }

        private func animate(to phase: AnimationPhase, completion: (() -> Void)? = nil) {
            if let completion {
                withAnimation(.spring(duration: phase.duration)) {
                    animationPhase = phase
                } completion: {
                    completion()
                }
            } else {
                withAnimation(.spring(duration: phase.duration)) {
                    animationPhase = phase
                }
            }
        }

        private var dragGesture: some Gesture {
            DragGesture(minimumDistance: 0)
                .onEnded { _ in
                    animate(to: .idle)
                }
        }
    #elseif os(macOS)
        @State private var isDeleteConfirmationDialogPresented = false
        @State private var animationTrigger = false
    #endif

    private func addEvent() {
        tip.invalidate(reason: .actionPerformed)
        #if os(iOS)
            withAnimation(.spring(duration: 0.4)) {
                successFeedbackTrigger.toggle()
                _ = modelContext.insertNewEvent(for: activity)
            }
        #elseif os(macOS)
            withAnimation {
                animationTrigger.toggle()
            } completion: {
                successFeedbackTrigger.toggle()
                _ = modelContext.insertNewEvent(for: activity)
            }
        #endif
    }

    #if os(macOS)
        private func deleteActivity() {
            withAnimation {
                Logger.general.info("Deleting activity with ID: \(activity.id, privacy: .public)")
                modelContext.delete(activity)
                modelContext.syncWidgets()
            }
        }
    #endif
}

#if DEBUG
    #Preview {
        Group {
            ActivityCard(activity: Mocks.activities[0])

            HStack {
                ActivityCard(activity: Mocks.activities[1])
                ActivityCard(activity: Mocks.activities[3])
            }
        }
        .modelContainer(ModelContainer.shared)
    }
#endif
