//
//  DebugCommands.swift
//  MimeerApp
//
//  Created by Caleb Friden on 9/29/23.
//

#if DEBUG

    import Foundation
    import SwiftUI
    import TipKit
    import SwiftData
    import MimeerKit

    public struct DebugCommands: Commands {
        @FocusedValue(\.modelContext) var modelContext: ModelContext?

        public init() {}

        public var body: some Commands {
            CommandMenu("Debug") {
                Button("Show All Tips") {
                    Tips.showAllTipsForTesting()
                }

                Button("Delete All", action: deleteAll)
                    .disabled(modelContext == nil)
            }
        }

        func deleteAll() {
            guard let modelContext else { return }

            let modelsFetchDescriptor = FetchDescriptor<Activity>()
            let models = try! modelContext.fetch(modelsFetchDescriptor)

            withAnimation {
                for model in models {
                    modelContext.delete(model)
                }
                if !models.isEmpty {
                    modelContext.syncWidgets()
                }
            }
        }
    }

#endif
