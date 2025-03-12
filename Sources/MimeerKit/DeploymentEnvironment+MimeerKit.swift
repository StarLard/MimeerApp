//
//  DeploymentEnvironment+MimeerKit.swift
//  MimeerKit
//
//  Created by Caleb Friden on 12/17/24.
//

import StarLardKit

extension DeploymentEnvironment {
    @MainActor public static var isRunningForScreenshots: Bool {
        get {
            #if DEBUG
                return _isRunningForScreenshots
            #else
                return false
            #endif
        }
        set {
            _isRunningForScreenshots = newValue
        }
    }

    @MainActor private static var _isRunningForScreenshots = false
}
