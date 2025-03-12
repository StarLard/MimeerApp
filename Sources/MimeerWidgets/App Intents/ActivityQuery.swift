//
//  ActivityQuery.swift
//  Mimeer Widgets
//
//  Created by Caleb Friden on 8/18/23.
//

import AppIntents
import Foundation
import MimeerKit
import OSLog
import SwiftData

struct ActivityQuery: EntityStringQuery {
    init() {
        Task { @MainActor in
            do {
                try ModelContainer.initializeSharedContainer()
            } catch {
                Logger.appIntents.critical(
                    "Failed to create model container with error: \(error.localizedDescription, privacy: .public)"
                )
            }
        }
    }

    @MainActor
    func entities(matching string: String) async throws -> [ActivityEntity] {
        let predicate = #Predicate<Activity> { activity in
            activity.title.localizedStandardContains(string)
        }
        let descriptor = FetchDescriptor<Activity>(
            predicate: predicate,
            sortBy: [SortDescriptor(\Activity.displayPriority), SortDescriptor(\Activity.title)])
        let modelContext = ModelContext(ModelContainer.shared)
        let activities = try modelContext.fetch(descriptor)
        return activities.map(ActivityEntity.init(activity:))
    }

    @MainActor
    func entities(for identifiers: [ActivityEntity.ID]) async throws -> [ActivityEntity] {
        let predicate = #Predicate<Activity> { activity in
            identifiers.contains(activity.id) && true
        }
        let descriptor = FetchDescriptor<Activity>(
            predicate: predicate,
            sortBy: [SortDescriptor(\Activity.displayPriority), SortDescriptor(\Activity.title)])
        let modelContext = ModelContext(ModelContainer.shared)
        let activities = try modelContext.fetch(descriptor)
        return activities.map(ActivityEntity.init(activity:))
    }

    @MainActor
    func suggestedEntities() async throws -> [ActivityEntity] {
        let descriptor = FetchDescriptor<Activity>(sortBy: [
            SortDescriptor(\Activity.displayPriority), SortDescriptor(\Activity.title),
        ])
        let modelContext = ModelContext(ModelContainer.shared)
        let activities = try modelContext.fetch(descriptor)
        return activities.map(ActivityEntity.init(activity:))
    }
}

// Supporting this is proving to be too much of a pain in the ass
// due to the difficulty of forming compound predicates with SwiftData
// Commenting out for now

//extension ActivityQuery: EntityPropertyQuery {
//    @MainActor
//    func entities(matching comparators: [Predicate<Activity>],
//                  mode: ComparatorMode,
//                  sortedBy: [EntityQuerySort<ActivityEntity>],
//                  limit: Int?) async throws -> [ActivityEntity] {
//        let predicate: Predicate<Activity>
//        if comparators.count < 2 {
//            predicate = comparators[0]
//        } else {
//            predicate = Predicate<Activity> { activity in
//                switch mode {
//                case .and:
//                    var expression = PredicateExpressions.build_Conjunction(lhs: comparators[0].expression, rhs: comparators[1].expression)
//                    for comparator in comparators[2..<comparators.count] {
//                        expression = PredicateExpressions.build_Conjunction(lhs: expression, rhs: comparator.expression)
//                    }
//                    return expression
//                case .or:
//                    var expression = PredicateExpressions.build_Disjunction(lhs: comparators[0].expression, rhs: comparators[1].expression)
//                    for comparator in comparators[2..<comparators.count] {
//                        expression = PredicateExpressions.build_Disjunction(lhs: expression, rhs: comparator.expression)
//                    }
//                    return expression
//                }
//            }
//        }
//
//              let sortDescriptors: [SortDescriptor<Activity>] = sortedBy.compactMap { (sort: EntityQuerySort<ActivityEntity>) -> SortDescriptor<Activity>? in
//                  switch sort.by {
//            case \ActivityEntity.title:
//                return SortDescriptor(\Activity.title, comparator: .lexical, order: sort.order.sortOrder)
//            case \ActivityEntity.lastEvent:
//                return SortDescriptor(\Activity.lastEvent?.timestamp, order: sort.order.sortOrder)
//            default:
//                DiagnosticReporter.shared.recordError("Failed to encode persistent identifier as string", assertOnSimulator: true)
//                return nil
//            }
//        }
//        var descriptor = FetchDescriptor<Activity>(predicate: predicate,
//                                                   sortBy: sortDescriptors)
//        descriptor.fetchLimit = limit
//        let activities = try modelContext.fetch(descriptor)
//        return activities.map(ActivityEntity.init(activity:))
//    }
//
//    static var properties = EntityQueryProperties<ActivityEntity, Predicate<Activity>> {
//        Property(\ActivityEntity.$title) {
//            EqualToComparator { title in
//                #Predicate<Activity> { activity in
//                    activity.title == title
//                }
//            }
//            ContainsComparator { title in
//                #Predicate<Activity> { activity in
//                    activity.title.localizedStandardContains(title)
//                }
//            }
//        }
//        Property(\ActivityEntity.$lastEvent) {
//            EqualToComparator { date in
//                #Predicate<Activity> { activity in
//                    activity.lastEvent?.timestamp == date
//                }
//            }
//            LessThanComparator { date in
//                #Predicate<Activity> { activity in
//                    activity.lastEvent?.timestamp ?? .distantFuture < date
//                }
//            }
//            LessThanOrEqualToComparator { date in
//                #Predicate<Activity> { activity in
//                    activity.lastEvent?.timestamp ?? .distantFuture <= date
//                }
//            }
//            GreaterThanComparator { date in
//                #Predicate<Activity> { activity in
//                    activity.lastEvent?.timestamp ?? .distantPast > date
//                }
//            }
//            GreaterThanOrEqualToComparator { date in
//                #Predicate<Activity> { activity in
//                    activity.lastEvent?.timestamp ?? .distantPast >= date
//                }
//            }
//        }
//    }
//
//    static var sortingOptions = SortingOptions {
//        SortableBy(\ActivityEntity.$title)
//        SortableBy(\ActivityEntity.$lastEvent)
//    }
//}
//
//private extension EntityQuerySort.Ordering {
//    var sortOrder: SortOrder {
//        switch self {
//        case .ascending:
//            return .forward
//        case .descending:
//            return .reverse
//        }
//    }
//}
