//
//  ActivityInsightsSummaryView.swift
//  MimeerApp
//
//  Created by Caleb Friden on 8/22/23.
//

import Charts
import MimeerKit
import StarLardKit
import SwiftData
import SwiftUI

struct ActivityInsightsSummaryView: View {
    var summary: ActivityInsightsSummary

    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack {
                HStack {
                    MeasurementLabel(
                        "Frequency",
                        metric: summary.averageFrequency,
                        unit: summary.dateFilter.frequencyUnit,
                        color: Color(summary.activity.color)
                    )
                    Spacer()
                    MeasurementLabel(
                        "Interval",
                        metric: summary.averageIntervalUnitized.value,
                        unit: summary.averageIntervalUnitized.unit,
                        color: Color(summary.activity.color)
                    )
                }
                .lineLimit(1)

                Chart {
                    ForEach(summary.dataPoints, id: \.date) { dataPoint in
                        Plot {
                            BarMark(
                                x: .value(
                                    "Date", dataPoint.date,
                                    unit: summary.dateFilter.displayGranularity),
                                y: .value("Total Count", dataPoint.numberOfEvents)
                            )
                            .foregroundStyle(
                                Color(summary.activity.color).gradient
                            )
                            .annotation(position: .top, alignment: .center) {
                                MeasurementLabel(
                                    metric: Double(dataPoint.numberOfEvents),
                                    unit: dataPoint.numberOfEvents == 1 ? "EVENT" : "EVENTS",
                                    color: Color(summary.activity.color)
                                ) {
                                    Text(
                                        summary.dateFilter.format(
                                            date: dataPoint.date, locale: locale))
                                }.background {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(.background)
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(.quaternary.opacity(0.6))
                                    }
                                    .padding(.horizontal, -8)
                                    .padding(.vertical, -4)
                                }
                                .padding(.bottom, 8)
                                .opacity(dataPoint == selectedDataPoint ? 1 : 0)
                            }
                        }
                        .accessibilityLabel("Number of Events")
                        .accessibilityValue("\(dataPoint.numberOfEvents)")
                    }
                }
                .chartOverlay { chart in
                    GeometryReader { geometry in
                        Rectangle()
                            .fill(Color.clear)
                            .contentShape(Rectangle())
                            #if os(iOS)
                                .gesture(
                                    DragGesture()
                                        .onChanged { value in
                                            selectDataPoint(
                                                at: value.location, in: chart, geometry: geometry)
                                        }
                                        .onEnded { _ in
                                            selectedDataPoint = nil
                                        }
                                )
                            #endif
                            .onContinuousHover { hoverPhase in
                                switch hoverPhase {
                                case .active(let hoverPoint):
                                    selectDataPoint(at: hoverPoint, in: chart, geometry: geometry)
                                case .ended:
                                    selectedDataPoint = nil
                                }
                            }
                    }
                }
            }
        }
        .padding()
    }

    private func selectDataPoint(at point: CGPoint, in chart: ChartProxy, geometry: GeometryProxy) {
        guard let plotFrame = chart.plotFrame else {
            return
        }
        let xPosition = point.x - geometry[plotFrame].origin.x
        guard (0..<chart.plotSize.width).contains(xPosition),
            let xValue = chart.value(atX: xPosition, as: Date.self)
        else {
            return
        }
        selectedDataPoint = summary.dataPoints.first(where: { dataPoint in
            dataPoint.numberOfEvents > 0
                && summary.calendar.isDate(
                    xValue, equalTo: dataPoint.date,
                    toGranularity: summary.dateFilter.displayGranularity)
        })
    }

    @State private var selectedDataPoint: ActivityInsightsSummary.DataPoint? = nil
    @Environment(\.locale) private var locale
}

extension ActivityInsightsSummaryView {
    fileprivate struct MeasurementLabel<Title: View>: View {
        init(
            metric: Double,
            unit: LocalizedStringKey,
            color: Color,
            @ViewBuilder title: () -> Title
        ) {
            self.title = title()
            self.metric = metric
            self.unit = unit
            self.color = color
        }
        var title: Title
        var metric: Double
        var unit: LocalizedStringKey
        var color: Color

        var body: some View {
            VStack(alignment: .leading) {
                title

                HStack(alignment: .firstTextBaseline, spacing: 4) {
                    Text(metric, format: .number)
                        .font(.system(size: metricFontSize, weight: .semibold, design: .monospaced))
                        .contentTransition(.numericText(value: metric))
                    Text(unit)
                        .font(.system(size: unitFontSize, weight: .semibold))
                }
                .foregroundStyle(color)
            }
        }

        @ScaledMetric(relativeTo: .title)
        private var metricFontSize = 24

        @ScaledMetric(relativeTo: .title)
        private var unitFontSize = 16
    }
}

extension ActivityInsightsSummaryView.MeasurementLabel where Title == Text {
    init(
        _ titleKey: LocalizedStringKey,
        metric: Double,
        unit: LocalizedStringKey,
        color: Color
    ) {
        self.init(metric: metric, unit: unit, color: color) {
            Text(titleKey)
        }
    }
}

#if DEBUG
    #Preview {
        List {
            ForEach(DateFilter.allCases, id: \.self) { filter in
                Section(filter.title) {
                    ActivityInsightsSummaryView(
                        summary: .init(
                            activity: Mocks.activities[0],
                            dateFilter: filter,
                            calendar: .current,
                            now: .current
                        )
                    )
                }
            }
        }
        .modelContainer(.shared)
    }
#endif
