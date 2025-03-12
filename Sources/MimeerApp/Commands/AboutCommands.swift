//
//  AboutCommands.swift
//  MimeerApp
//
//  Created by Caleb Friden on 10/1/23.
//

import Foundation
import SwiftUI

struct AboutCommands: Commands {
    @Environment(\.openWindow) var openWindow

    var body: some Commands {
        CommandGroup(replacing: .appInfo) {
            Button("About \(AppInfo.displayName)", action: showAboutView)
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
