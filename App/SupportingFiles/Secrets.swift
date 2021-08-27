// Copyright © 2021 PACE Telematics GmbH. All rights reserved.

import Foundation

enum Secrets {
    static let clientID: String = environmentVariable(named: "PACE_CLOUD_CLIENT_ID") ?? "${PACE_CLOUD_CLIENT_ID}"
    static let cloudURL: String = environmentVariable(named: "PACE_CLOUD_URL") ?? "{PACE_CLOUD_URL}"
    static let apiKey: String = environmentVariable(named: "PACE_CLOUD_API_KEY") ?? "${PACE_CLOUD_API_KEY}"
    static let redirectURI: String = environmentVariable(named: "PACE_CLOUD_REDIRECT_URI") ?? "${PACE_CLOUD_REDIRECT_URI}"

    private static func environmentVariable(named: String) -> String? {
        let processInfo = ProcessInfo.processInfo

        guard let value = processInfo.environment[named] else {
            print("‼️ Missing Environment Variable: '\(named)'")
            return nil
        }

        return value
    }
}
