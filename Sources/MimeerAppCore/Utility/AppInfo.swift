//
//  AppInfo.swift
//  MimeerApp
//
//  Created by Caleb Friden on 7/23/23.
//

import Foundation
import StarLardKit

#if os(iOS)
    import UIKit
#elseif os(macOS)
    import AppKit
#endif

/// Contains plist and process info
public enum AppInfo {
    /// The app's display name
    public static let displayName: String = String(
        localized: "Mimeer", comment: "The display name for the app")

    /// An automatically generated ID assigned to the app by Apple.
    static let appleID: String = "6468530044"

    static var bundleIdentifier: String {
        guard let identifier = Bundle.main.bundleIdentifier else {
            fatalError("Could not determine bundle identifier string from main bundle plist")
        }
        return identifier
    }

    static var versionString: String {
        guard let plist = Bundle.main.infoDictionary,
            let versionString = plist["CFBundleShortVersionString"] as? String
        else {
            fatalError("Could not determine version string from main bundle plist")
        }
        return versionString
    }

    static var buildString: String {
        guard let plist = Bundle.main.infoDictionary,
            let versionString = plist["CFBundleVersion"] as? String
        else {
            fatalError("Could not determine build string from main bundle plist")
        }
        return versionString
    }

    static var appStoreURL: URL {
        return URL(string: "itms-apps://itunes.apple.com/us/app/apple-store/id\(appleID)?mt=8")!
    }

    static var version: AppVersion {
        guard let version = AppVersion(AppInfo.versionString) else {
            fatalError("Version string from main bundle plist was in unexpected format")
        }
        return version
    }

    #if os(iOS)
        static var iconName: String {
            guard let plist = Bundle.main.infoDictionary,
                let icons = plist["CFBundleIcons"] as? [String: Any],
                let primaryIcon = icons["CFBundlePrimaryIcon"] as? [String: Any],
                let iconFiles = primaryIcon["CFBundleIconFiles"] as? [String],
                let name = iconFiles.last
            else {
                fatalError("Could not load icon from main bundle plist")
            }
            return name
        }

        static var icon: UIImage {
            guard let image = UIImage(named: iconName) else {
                fatalError("Could not load icon from main bundle plist")
            }
            return image
        }
    #elseif os(macOS)
        static var iconName: String {
            guard let plist = Bundle.main.infoDictionary,
                let name = plist["CFBundleIconName"] as? String
            else {
                fatalError("Could not load icon from main bundle plist")
            }
            return name
        }

        static var icon: NSImage {
            guard let image = NSImage(named: iconName) else {
                fatalError("Could not load icon from main bundle plist")
            }
            return image
        }
    #endif

    static let marketingURL: URL = URL(string: "https://mimeer.starlard.dev")!
    static let privacyURL: URL = URL(string: "https://mimeer.starlard.dev/privacy")!
    static let supportURL: URL = URL(string: "https://mimeer.starlard.dev/support")!
    static let sourceURL: URL = URL(string: "https://github.com/StarLard/MimeerApp")!
}
