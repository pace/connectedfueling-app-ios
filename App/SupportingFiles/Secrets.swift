// Copyright © 2021 PACE Telematics GmbH. All rights reserved.

import Foundation

enum Secrets {
    static let apiKey: String = "PACE"

    private static func environmentVariable(named: String) -> String? {
        let processInfo = ProcessInfo.processInfo

        guard let value = processInfo.environment[named] else {
            print("‼️ Missing Environment Variable: '\(named)'")
            return nil
        }

        return value
    }
}
