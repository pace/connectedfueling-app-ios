import Foundation

// swiftlint:disable type_name
extension String: Identifiable {
    public typealias ID = Int

    public var id: Int {
        return hash
    }
}

// MARK: - Localization
private var fallbackLocalizationBundle: Bundle?

extension String {
    func localized(_ tableName: String? = nil, bundle: Bundle = Bundle.main, value: String = "", comment: String = "") -> String {
        var localizedString = NSLocalizedString(self, tableName: tableName, bundle: bundle, value: value, comment: comment)

        if localizedString == self || localizedString.isEmpty {
            if fallbackLocalizationBundle == nil {
                if let fallbackLanguage = Bundle.main.infoDictionary?["CFBundleDevelopmentRegion"] as? String,
                   let fallbackBundlePath = Bundle.main.path(forResource: fallbackLanguage, ofType: "lproj") {
                    fallbackLocalizationBundle = Bundle(path: fallbackBundlePath)
                }
            }

            if let fallbackString = fallbackLocalizationBundle?.localizedString(forKey: self, value: value, table: tableName) {
                localizedString = fallbackString
            }
        }

        return localizedString
    }

    var localized: String {
        self.localized()
    }
}
