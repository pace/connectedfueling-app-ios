import Foundation

protocol AnalyticsService {
    func setup()
    func updateActivationState()
    func logEvent(_ event: AnalyticEvent)
    func logEvent(key: String, parameters: [String: Any])
}
