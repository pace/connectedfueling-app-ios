// Copyright © 2023 PACE Telematics GmbH. All rights reserved.

import Foundation

class AnalyticsManager: AnalyticsService {
    private var firebaseService: AnalyticsService?

    init() {
        #if ANALYTICS
        firebaseService = FirebaseService()
        #endif
    }

    func setup() {
        firebaseService?.setup()
    }

    func updateActivationState() {
        firebaseService?.updateActivationState()
    }

    func logEvent(_ event: AnalyticEvent) {
        firebaseService?.logEvent(event)
    }

    func logEvent(key: String, parameters: [String: Any]) {
        firebaseService?.logEvent(key: key, parameters: parameters)
    }
}
