//
//  AppBanner.swift
//  MimeerApp
//
//  Created by Caleb Friden on 8/17/23.
//

#if os(iOS)

    import SwiftUI

    struct AppBanner: View {
        @State private var isBuildShown = false

        var body: some View {
            HStack {
                Image(uiImage: AppInfo.icon)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(RoundedRectangle(cornerRadius: 16))

                VStack(alignment: .leading) {
                    Text(AppInfo.displayName)
                        .font(.headline)

                    Text(
                        isBuildShown
                            ? "\(AppInfo.version.description) (\(AppInfo.buildString))"
                            : "\(AppInfo.version.description)"
                    )
                    .font(.subheadline)
                    .contextMenu {
                        Button {
                            withAnimation {
                                isBuildShown.toggle()
                            }
                        } label: {
                            if isBuildShown {
                                Label("Hide Full Version", systemImage: "eye.slash")
                            } else {
                                Label("Show Full Version", systemImage: "eye")
                            }
                        }

                        Button {
                            let versionString =
                                "\(AppInfo.version.description) (\(AppInfo.buildString)"
                            UIPasteboard.general.string = versionString
                        } label: {
                            Label("Copy", systemImage: "doc.on.doc")
                        }
                    }
                }
            }
            .fixedSize()
            .padding(.vertical)
        }
    }

    #Preview {
        AppBanner()
    }

#endif
