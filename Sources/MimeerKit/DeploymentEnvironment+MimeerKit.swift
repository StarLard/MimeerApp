//
//  DeploymentEnvironment+MimeerKit.swift
//  MimeerKit
//
//  Created by Caleb Friden on 12/17/24.
//

import StarLardKit

extension DeploymentEnvironment {
    public static let isRunningForScreenshots: Bool = {
        #if DEBUG
            return false
        #else
            return false
        #endif
    }()
}
