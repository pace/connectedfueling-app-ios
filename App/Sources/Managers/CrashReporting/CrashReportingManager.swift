import Foundation

class CrashReportingManager: CrashReportingService {
    private var crashlyticsService: CrashReportingService?
    private var sentryService: CrashReportingService?

    static let shared: CrashReportingManager = .init()

    private init() {
        #if CRASHLYTICS
        crashlyticsService = CrashlyticsService()
        #endif

        #if SENTRY
        sentryService = SentryService()
        #endif
    }

    func setup() {
        [crashlyticsService, sentryService].forEach {
            $0?.setup()
        }
    }

    func sendEvent(level: BugLevel, message: String, parameters: [String: Any]?) {
        [crashlyticsService, sentryService].forEach {
            $0?.sendEvent(level: level, message: message, parameters: parameters)
        }
    }

    func reportError(_ error: Error) {
        [crashlyticsService, sentryService].forEach {
            $0?.reportError(error)
        }
    }

    func setBreadcrumb(_ message: String, parameters: [String: Any]?) {
        [crashlyticsService, sentryService].forEach {
            $0?.setBreadcrumb(message, parameters: parameters)
        }
    }
}
