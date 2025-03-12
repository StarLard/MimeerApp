//
//  AboutCommands.swift
//  MimeerApp
//
//  Created by Caleb Friden on 10/1/23.
//

import Foundation
import SwiftUI

public struct AboutCommands: Commands {
    @Environment(\.openWindow) var openWindow

    public init() {}

    public var body: some Commands {
        CommandGroup(replacing: .appInfo) {
            Button("About \(AppInfo.displayName)", action: showAboutView)
            Link("View Source", destination: AppInfo.sourceURL)
        }
    }

    private func showAboutView() {
        withAnimation {
            openWindow(id: "about-mimeer")
        }
    }
}
struct IsAboutViewPresentedKey: FocusedValueKey {
    typealias Value = Binding<Bool>
}

extension FocusedValues {
    var isAboutViewPresented: IsAboutViewPresentedKey.Value? {
        get { self[IsAboutViewPresentedKey.self] }
        set { self[IsAboutViewPresentedKey.self] = newValue }
    }
}
