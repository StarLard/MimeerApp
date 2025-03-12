//
//  PrivacyInfoView.swift
//  MimeerApp
//
//  Created by Caleb Friden on 8/17/23.
//

import SwiftUI

struct PrivacyInfoView: View {
    @AppStorage(UserDefaultsKey.isDiagnosticsReportingEnabled)
    private var isDiagnosticsReportingEnabled = true

    var body: some View {
        VStack {
            List {
                Section {
                    Toggle("Send Diagnostics", isOn: $isDiagnosticsReportingEnabled)
                } footer: {
                    Text(
                        "Crash and perfromance data is critical in enabling the developer to quickly identify and fix issues."
                    )
                }
            }

            Text(
                .init(
                    "All data collected is anonymous and never shared. \(AppInfo.displayName) and its developer take your privacy very seriously. To learn more, read our [privacy policy](\(AppInfo.privacyURL))"
                )
            )
            .font(.caption)
            .foregroundStyle(.secondary)
            .multilineTextAlignment(.center)
            .padding()
        }
        .backgroundStyle(.tertiary)
        .navigationTitle("Privacy")
        .onChange(of: isDiagnosticsReportingEnabled) { _, newValue in
            if newValue {
                DiagnosticReporter.shared.start()
            } else {
                DiagnosticReporter.shared.stop()
            }
        }
    }
}

#Preview {
    PrivacyInfoView()
}
