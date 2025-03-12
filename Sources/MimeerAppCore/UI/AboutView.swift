//
//  AboutView.swift
//  MimeerApp
//
//  Created by Caleb Friden on 10/1/23.
//

#if os(macOS)

    import SwiftUI

    public struct AboutView: View {

        public init() {}

        public var body: some View {
            HStack(alignment: .center) {
                Image(nsImage: AppInfo.icon)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 96, height: 96)
                    #if os(iOS)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                    #endif

                VStack(alignment: .leading, spacing: 16) {
                    VStack(alignment: .leading) {
                        Text(AppInfo.displayName)
                            .font(.title)

                        Text("Version \(AppInfo.version.description) (\(AppInfo.buildString))")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .textSelection(.enabled)
                    }

                    CopyrightNotice()
                        .foregroundStyle(.secondary)

                    HStack {
                        Link(destination: AppInfo.appStoreURL) {
                            Label("Rate", systemImage: "suit.heart")
                        }
                    }
                    .buttonStyle(.bordered)
                }
            }
            .fixedSize()
            .padding()
        }
    }

    #Preview {
        AboutView()
    }

#endif
