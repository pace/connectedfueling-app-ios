#if CRASHLYTICS

import Firebase
import Foundation

extension CrashReportingManager {
    struct CrashlyticsService: CrashReportingService {
        func setup() {
            guard FirebaseApp.app() == nil else { return }
            FirebaseApp.configure()
        }

        func reportError(_ error: Error) {
            Crashlytics.crashlytics().record(error: error)
        }

        func setBreadcrumb(_ message: String, parameters: [String: Any]?) {
            let breadcrumbMessage = concatenatedCrashReport(message, parameters: parameters)
            Crashlytics.crashlytics().log(breadcrumbMessage)
        }

        func sendEvent(level: CrashReportingManager.BugLevel, message: String, parameters: [String: Any]?) {}
    }
}

#endif
