//
//  SettingsView.swift
//  MimeerApp
//
//  Created by Caleb Friden on 8/17/23.
//

import MimeerKit
import SwiftData
import SwiftUI
import TipKit

public struct SettingsView: View {
    #if os(iOS)
        @Environment(\.dismiss) private var dismiss
        @Environment(\.modelContext) private var modelContext

        public init() {}

        public var body: some View {
            NavigationStack {
                List {
                    Section(
                        header: AppBanner(),
                        footer: CopyrightNotice()
                    ) {
                        Link(destination: AppInfo.appStoreURL) {
                            Label("Rate \(AppInfo.displayName)", systemImage: "suit.heart")
                        }
                        Link(destination: AppInfo.supportURL) {
                            Label("Support", systemImage: "wrench.and.screwdriver")
                        }
                        NavigationLink(destination: PrivacyInfoView()) {
                            Label("Privacy", systemImage: "hand.raised")
                        }
                        NavigationLink(destination: UserFeedbackView()) {
                            Label("Send Feedback", systemImage: "envelope")
                        }
                    }

                    #if DEBUG
                        Section {
                            Button {
                                Tips.showAllTipsForTesting()
                            } label: {
                                Text(verbatim: "Show all tips")
                            }

                            Button(role: .destructive, action: deleteAll) {
                                Text(verbatim: "Delete All")
                            }
                        } header: {
                            Text(verbatim: "Debug")
                        }
                    #endif
                }
                .listStyle(InsetGroupedListStyle())
                .navigationBarTitleDisplayMode(.large)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Done") {
                            withAnimation {
                                dismiss()
                            }
                        }
                    }
                }
                .navigationTitle("Settings")
            }
        }

        #if DEBUG
            func deleteAll() {
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
        #endif

    #elseif os(macOS)
        var body: some View {
            TabView {
                PrivacyInfoView()
                    .tabItem {
                        Label("Privacy", systemImage: "hand.raised")
                    }
                    .tag(Tabs.privacy)
            }
            .padding()
        }

        private enum Tabs: Hashable {
            case privacy
        }
    #endif
}

#Preview {
    SettingsView()
}
