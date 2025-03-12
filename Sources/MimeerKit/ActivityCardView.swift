//
//  ActivityCardView.swift
//  MimeerKit
//
//  Created by Caleb Friden on 8/30/23.
//

import SwiftData
import SwiftUI

public struct ActivityCardView: View {
    public var activityTitle: String
    public var activityLastEvent: Date?
    public var activityColor: Color
    public var activityIcon: SFSymbol
    public var isSelected: Bool
    public var autoupdateRelativeDateForLastEvent: Bool
    public var animationPhase: AnimationPhase
    public var willBeDisplayedOnTransparentBackground: Bool
    public var sizeClass: SizeClass
    public var successFeedbackTrigger: Bool

    public enum AnimationPhase: CaseIterable {
        case idle
        case hidingDetails
        case expandingIcon
        case replacingIcon
        case showingDetails

        public var duration: TimeInterval {
            switch self {
            case .idle:
                return 0.2
            case .hidingDetails:
                return 0.2
            case .expandingIcon:
                return 0.4
            case .replacingIcon:
                return 0.5
            case .showingDetails:
                return 0.2
            }
        }
    }

    public enum SizeClass {
        case compact
        case narrow
        case `default`
    }

    public init(
        activity: Activity,
        isSelected: Bool,
        autoupdateRelativeDateForLastEvent: Bool,
        animationPhase: ActivityCardView.AnimationPhase,
        willBeDisplayedOnTransparentBackground: Bool = false,
        sizeClass: SizeClass = .default,
        successFeedbackTrigger: Bool
    ) {
        self.init(
            activityTitle: activity.title,
            activityLastEvent: activity.lastEvent?.timestamp,
            activityColor: Color(activity.color),
            activityIcon: activity.icon,
            isSelected: isSelected,
            autoupdateRelativeDateForLastEvent: autoupdateRelativeDateForLastEvent,
            animationPhase: animationPhase,
            willBeDisplayedOnTransparentBackground: willBeDisplayedOnTransparentBackground,
            successFeedbackTrigger: successFeedbackTrigger
        )
    }

    public init(
        activityTitle: String,
        activityLastEvent: Date?,
        activityColor: Color,
        activityIcon: SFSymbol,
        isSelected: Bool,
        autoupdateRelativeDateForLastEvent: Bool,
        animationPhase: ActivityCardView.AnimationPhase,
        willBeDisplayedOnTransparentBackground: Bool = false,
        sizeClass: SizeClass = .default,
        successFeedbackTrigger: Bool
    ) {
        self.activityTitle = activityTitle
        self.activityLastEvent = activityLastEvent
        self.activityColor = activityColor
        self.activityIcon = activityIcon
        self.isSelected = isSelected
        self.autoupdateRelativeDateForLastEvent = autoupdateRelativeDateForLastEvent
        self.animationPhase = animationPhase
        self.willBeDisplayedOnTransparentBackground = willBeDisplayedOnTransparentBackground
        self.sizeClass = sizeClass
        self.successFeedbackTrigger = successFeedbackTrigger
    }

    public var body: some View {
        GeometryReader { proxy in
            VStack(alignment: .leading) {
                HStack(alignment: .top) {
                    Image(systemName: iconName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundStyle(foregroundStyle)
                        .frame(
                            maxWidth: iconSize(containerSize: proxy.size).width,
                            maxHeight: iconSize(containerSize: proxy.size).width
                        )
                        .contentTransition(.symbolEffect(.replace))
                        .padding(iconPadding)
                        .symbolEffect(.bounce, value: successFeedbackTrigger)
                        .sensoryFeedback(.success, trigger: successFeedbackTrigger)

                    if let lastEvent = activityLastEvent, dateLabelAxis == .horizontal, animationPhase == .idle {
                        Spacer(minLength: 4)

                        dateLabel(date: lastEvent)
                            .transition(.move(edge: .trailing))
                    }
                }

                if animationPhase == .idle {
                    Spacer(minLength: 0)

                    Text(activityTitle)
                        .lineLimit(titleLineLimit)
                        .multilineTextAlignment(.leading)
                        .font(titleFont)
                        .foregroundStyle(foregroundStyle)
                        .transaction { transaction in
                            transaction.animation = .linear.speed(2)
                        }
                        .transition(.move(edge: .bottom))

                    if let lastEvent = activityLastEvent, dateLabelAxis == .vertical, animationPhase == .idle {
                        dateLabel(date: lastEvent)
                            .transition(.move(edge: .bottom))
                    }
                }
            }
        }
    }

    private func dateLabel(date: Date) -> some View {
        RelativeDateText(date: date, autoupdate: autoupdateRelativeDateForLastEvent)
            .font(dateFont.monospacedDigit())
            .lineLimit(2)
            .multilineTextAlignment(.trailing)
            .foregroundStyle(foregroundStyle)
            .transaction { transaction in
                transaction.animation = .linear.speed(2)
            }
    }

    private var foregroundStyle: Color {
        (willBeDisplayedOnTransparentBackground || isSelected) ? activityColor : .white
    }

    private var dateLabelAxis: Axis {
        switch sizeClass {
        case .compact, .narrow:
            return .vertical
        case .default:
            return .horizontal
        }
    }

    private var titleLineLimit: Int? {
        switch sizeClass {
        case .compact:
            return 1
        case .default, .narrow:
            return 3
        }
    }

    private var titleFont: Font {
        switch sizeClass {
        case .compact:
            return .subheadline
        case .default, .narrow:
            return .headline
        }
    }

    private var dateFont: Font {
        switch sizeClass {
        case .compact, .narrow:
            return .footnote
        case .default:
            return .subheadline
        }
    }

    private var iconName: String {
        switch animationPhase {
        case .idle, .hidingDetails, .expandingIcon:
            return activityIcon.systemName
        case .replacingIcon, .showingDetails:
            return "checkmark.circle"
        }
    }

    private var iconPadding: CGFloat {
        switch animationPhase {
        case .idle, .hidingDetails, .showingDetails:
            return 0
        case .replacingIcon, .expandingIcon:
            return 32
        }
    }

    private func iconSize(containerSize: CGSize) -> CGSize {
        switch animationPhase {
        case .idle, .hidingDetails, .showingDetails:
            switch sizeClass {
            case .compact:
                return CGSize(width: 24, height: 24)
            case .narrow:
                return CGSize(width: 36, height: 36)
            case .default:
                return CGSize(width: 48, height: 48)
            }
        case .replacingIcon, .expandingIcon:
            return containerSize
        }
    }
}

#if DEBUG
    private struct ActivityCardViewPalette: View {
        var willBeDisplayedOnTransparentBackground: Bool

        @MainActor
        init(willBeDisplayedOnTransparentBackground: Bool) {
            self.willBeDisplayedOnTransparentBackground = willBeDisplayedOnTransparentBackground
            try? ModelContainer.initializeSharedContainer()
        }

        var body: some View {
            VStack {
                ActivityCardView(
                    activity: Mocks.activities[0],
                    isSelected: false,
                    autoupdateRelativeDateForLastEvent: true,
                    animationPhase: .idle,
                    willBeDisplayedOnTransparentBackground: willBeDisplayedOnTransparentBackground,
                    sizeClass: .default,
                    successFeedbackTrigger: true
                )

                HStack {
                    ActivityCardView(
                        activity: Mocks.activities[1],
                        isSelected: false,
                        autoupdateRelativeDateForLastEvent: true,
                        animationPhase: .idle,
                        willBeDisplayedOnTransparentBackground: willBeDisplayedOnTransparentBackground,
                        sizeClass: .narrow,
                        successFeedbackTrigger: true
                    )

                    ActivityCardView(
                        activity: Mocks.activities[2],
                        isSelected: false,
                        autoupdateRelativeDateForLastEvent: true,
                        animationPhase: .idle,
                        willBeDisplayedOnTransparentBackground: willBeDisplayedOnTransparentBackground,
                        sizeClass: .narrow,
                        successFeedbackTrigger: true
                    )
                }

                HStack {
                    ActivityCardView(
                        activity: Mocks.activities[2],
                        isSelected: false,
                        autoupdateRelativeDateForLastEvent: true,
                        animationPhase: .idle,
                        willBeDisplayedOnTransparentBackground: willBeDisplayedOnTransparentBackground,
                        sizeClass: .compact,
                        successFeedbackTrigger: true
                    )

                    ActivityCardView(
                        activity: Mocks.activities[3],
                        isSelected: false,
                        autoupdateRelativeDateForLastEvent: true,
                        animationPhase: .idle,
                        willBeDisplayedOnTransparentBackground: willBeDisplayedOnTransparentBackground,
                        sizeClass: .compact,
                        successFeedbackTrigger: true
                    )
                }
            }
            .modelContainer(ModelContainer.shared)
        }
    }

    #Preview("default") {
        ActivityCardViewPalette(willBeDisplayedOnTransparentBackground: false)
            .background(.gray)
    }

    #Preview("transparent") {
        ActivityCardViewPalette(willBeDisplayedOnTransparentBackground: true)
    }

    #Preview("phases") {
        try? ModelContainer.initializeSharedContainer()

        return VStack {
            ForEach(ActivityCardView.AnimationPhase.allCases, id: \.self) { animationPhase in
                VStack {
                    Text(String(describing: animationPhase.self))
                    ActivityCardView(
                        activity: Mocks.activities[0],
                        isSelected: false,
                        autoupdateRelativeDateForLastEvent: true,
                        animationPhase: animationPhase,
                        successFeedbackTrigger: true
                    )
                    .background(Color.gray)
                }
            }
        }
        .modelContainer(.shared)
    }
#endif
