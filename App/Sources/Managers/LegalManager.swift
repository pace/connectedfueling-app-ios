import Foundation

struct LegalManager {

    enum Kind {
        case terms
        case dataPrivacy
        case tracking

        var acceptedLanguage: String? {
            switch self {
            case .terms:
                UserDefaults.termsAcceptedLocale

            case .dataPrivacy:
                UserDefaults.dataPrivacyAcceptedLocale

            case .tracking:
                UserDefaults.trackingAcceptedLocale
            }
        }

        var acceptedHash: String? {
            switch self {
            case .terms:
                UserDefaults.termsAcceptedHash

            case .dataPrivacy:
                UserDefaults.dataPrivacyAcceptedHash

            case .tracking:
                UserDefaults.trackingAcceptedHash
            }
        }

        var fileName: String {
            switch self {
            case .terms:
                Constants.File.termsOfUse

            case .dataPrivacy:
                Constants.File.dataPrivacy

            case .tracking:
                Constants.File.analytics
            }
        }
    }

    enum DocumentStatus {
        /// Document hash was never stored and is completely new
        case new
        /// Document hash changed since last acceptance
        case changed
        /// Document hash is unchanged
        case unchanged
        /// Document was never accepted (only for tracking)
        case notAccepted
        /// The feature is disabled
        case disabled
    }

    struct LegalDocumentsStatus {
        var terms: DocumentStatus
        var dataPrivacy: DocumentStatus
        var tracking: DocumentStatus
    }

    var configuration: ConfigurationManager.Configuration

    init(configuration: ConfigurationManager.Configuration = ConfigurationManager.configuration) {
        self.configuration = configuration
    }

    // MARK: Check for updates
    /// Check whether terms, data privacy or tracking documents have changed.
    /// Returns nil when called before onboarding is complete.
    func checkForUpdates() async -> LegalDocumentsStatus? {
        guard UserDefaults.isOnboardingCompleted else {
            return nil
        }
        async let termsChange = checkForUpdate(.terms)
        async let dataPrivacyChange = checkForUpdate(.dataPrivacy)
        async let trackingChange = checkForUpdate(.tracking)

        return await .init(terms: termsChange, dataPrivacy: dataPrivacyChange, tracking: trackingChange)
    }

    private func checkForUpdate(_ termsKind: Kind) async -> DocumentStatus {
        if termsKind == .tracking {
            if !configuration.isAnalyticsEnabled {
                return .disabled
            } else if !UserDefaults.isAnalyticsAllowed && UserDefaults.didAskForAnalytics {
                return .notAccepted
            }
        }

        guard let acceptedLanguage = termsKind.acceptedLanguage,
              let storedHash = termsKind.acceptedHash else {
            return .new
        }

        let newHash = SystemManager.loadHTMLHashFromBundle(fileName: termsKind.fileName, for: acceptedLanguage)
        return newHash == storedHash ? .unchanged : .changed
    }

    // MARK: Acceptance
    func accept(_ termsKind: Kind, for locale: String = SystemManager.languageCode) {
        let hash = SystemManager.loadHTMLHashFromBundle(fileName: termsKind.fileName, for: locale)
        switch termsKind {
        case .terms:
            UserDefaults.termsAcceptedLocale = locale
            UserDefaults.termsAcceptedHash = hash

        case .dataPrivacy:
            UserDefaults.dataPrivacyAcceptedLocale = locale
            UserDefaults.dataPrivacyAcceptedHash = hash

        case .tracking:
            UserDefaults.trackingAcceptedLocale = locale
            UserDefaults.trackingAcceptedHash = hash
        }
    }
}
