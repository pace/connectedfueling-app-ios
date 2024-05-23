protocol CrashReportingService {
    func setup()
    func sendEvent(level: CrashReportingManager.BugLevel, message: String, parameters: [String: Any]?)
    func reportError(_ error: Error)
    func setBreadcrumb(_ message: String, parameters: [String: Any]?)
}

extension CrashReportingService {
    func concatenatedCrashReport(_ message: String, parameters: [String: Any]?) -> String {
        let concatenatedMessage: String = (parameters ?? [:]).reduce(into: message) {
            $0 += "\n\($1.key): \($1.value)"
        }
        return concatenatedMessage
    }
}
