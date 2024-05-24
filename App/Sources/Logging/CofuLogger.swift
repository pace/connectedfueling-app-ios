import PACECloudSDK

class CofuLogger: Logger {
    private static let crashReportingManager = CrashReportingManager.shared

    override class var logTag: String {
        "[\(ConfigurationManager.configuration.clientId)]"
    }

    override static func d(_ message: String) {
        crashReportingManager.setBreadcrumb(message, parameters: nil)
        super.d(message)
    }

    override static func i(_ message: String) {
        crashReportingManager.setBreadcrumb(message, parameters: nil)
        super.i(message)
    }

    override static func w(_ message: String) {
        crashReportingManager.setBreadcrumb(message, parameters: nil)
        super.w(message)
    }

    override static func e(_ message: String) {
        crashReportingManager.setBreadcrumb(message, parameters: nil)
        super.e(message)
    }
}
