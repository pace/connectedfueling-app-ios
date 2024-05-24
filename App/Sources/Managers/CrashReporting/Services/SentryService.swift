#if SENTRY

import Foundation
import Sentry

extension CrashReportingManager {
    struct SentryService: CrashReportingService {
        func setup() {
            guard let sentryDSN = Bundle.main.infoDictionary?[Constants.CrashReporting.sentryDSNInfoPlistKey] as? String else {
                fatalError("[SentryService] No SentryDSN found in Info.plist")
            }

            SentrySDK.start { options in
                options.dsn = sentryDSN
                options.environment = Constants.currentEnvironment.short

                #if !PRODUCTION
                // When the app is running without a debugger attached
                // and you install a build via Xcode,
                // Sentry oftentimes throws a "Watchdog" error
                // because the running app suddenly got terminated
                options.enableWatchdogTerminationTracking = false
                #endif
            }
        }

        func sendEvent(level: CrashReportingManager.BugLevel, message: String, parameters: [String: Any]?) {
            let sentryLevel: SentryLevel = switch level {
                case .debug:
                    .debug

                case .info:
                    .info

                case .error:
                    .error

                case .warning:
                    .warning

                case .fatal:
                    .fatal
            }

            let event = Event(level: sentryLevel)
            let eventMessage = concatenatedCrashReport(message, parameters: parameters)
            event.message = SentryMessage(formatted: eventMessage)

            SentrySDK.capture(event: event)
        }

        func reportError(_ error: Error) {
            let nsError = error as NSError
            sendEvent(level: .error, message: "Non-fatal exception occurred with code \(nsError.code)", parameters: nsError.userInfo)
        }

        func setBreadcrumb(_ message: String, parameters: [String: Any]?) {
            let crumb = Breadcrumb()
            let breadcrumbMessage = concatenatedCrashReport(message, parameters: parameters)
            crumb.message = breadcrumbMessage
            SentrySDK.addBreadcrumb(crumb)
        }
    }
}

#endif
