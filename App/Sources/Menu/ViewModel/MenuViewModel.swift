import PACECloudSDK
import SwiftUI
import WebKit

class MenuViewModel: NSObject, ObservableObject {
    @Published private(set) var listItems: [ListItem] = []

    private let crashReportingManager: CrashReportingManager
    private let analyticsManager: AnalyticsManager

    init(crashReportingManager: CrashReportingManager = .shared,
         analyticsManager: AnalyticsManager,
         configuration: ConfigurationManager.Configuration = ConfigurationManager.configuration) {
        self.crashReportingManager = crashReportingManager
        self.analyticsManager = analyticsManager

        super.init()

        var listItems: [ListItem] = [
            termsListItem,
            dataPrivacyListItem,
            imprintListItem
        ]

        if configuration.isAnalyticsEnabled {
            listItems.append(analyticsListItem)
        }

        listItems.append(permissionsListItem)

        self.listItems = listItems

        addCustomMenuEntries()
    }

    private func addCustomMenuEntries() {
        guard let menuEntries = ConfigurationManager.configuration.menuEntries else { return }

        let languageCode = SystemManager.languageCode
        let customListItems: [ListItem] = menuEntries.compactMap { menuEntry in
            let menuItems = menuEntry.menuEntryId.menuItems

            guard let menuItem = menuItems.first(where: { $0.languageCode.hasPrefix(languageCode) }) ??
                    menuItems.first(where: { $0.languageCode.hasPrefix(Constants.fallbackLanguageCode) })
            else {
                let errorMessage = "[MenuViewModel] Couldn't find menu entry neither for language \(languageCode) nor for fallback language 'en'."
                logError(errorMessage)
                return nil
            }

            if menuItem.hasHtml {
                let listItem: ListItem = .init(icon: .menuExternalSiteIcon,
                                               title: menuItem.name,
                                               action: .presentedContent(AnyView(
                                                    WebView(htmlString: loadCustomHtmlString(withName: menuEntry.menuEntryId.id ),
                                                            delegate: self)
                                               )))
                return listItem
            } else if let urlString = menuItem.url,
                      let url = URL(string: urlString) {
                let listItem: ListItem = .init(icon: .menuExternalSiteIcon,
                                               title: menuItem.name,
                                               action: .presentedContent(AnyView(
                                                SafariView(url: url)
                                                    .ignoresSafeArea()
                                               )))
                return listItem
            } else {
                let errorMessage = "[MenuViewModel] No HTML string and URL string \(menuItem.url) of menu item \(menuItem.name) for language \(menuItem.languageCode) is not a valid URL."
                logError(errorMessage)
                return nil
            }
        }

        self.listItems += customListItems
    }

    private func loadLegalHtmlString(kind: ConsentManager.Kind) -> String {
        return SystemManager.loadHTMLFromBundle(fileName: kind.fileName, for: kind.acceptedLanguage ?? SystemManager.languageCode)
    }

    private func loadImprintHtmlString() -> String {
        SystemManager.loadHTMLFromBundle(fileName: Constants.File.imprint)
    }

    private func loadCustomHtmlString(withName name: String) -> String {
        SystemManager.loadHTMLFromBundle(fileName: name, inDirectory: "CustomMenuHtmlEntries/\(SystemManager.languageCode)")
    }

    private func logError(_ message: String) {
        CofuLogger.e(message)
        crashReportingManager.sendEvent(level: .warning, message: message, parameters: nil)
    }
}

private extension MenuViewModel {
    var termsListItem: ListItem {
        .init(icon: .menuTermsIcon,
              title: L10n.Menu.Items.terms,
              action: .presentedContent(AnyView(
                WebView(htmlString: loadLegalHtmlString(kind: .terms))
              )))
    }

    var dataPrivacyListItem: ListItem {
        .init(icon: .menuDataPrivacyIcon,
              title: L10n.Menu.Items.privacy,
              action: .presentedContent(AnyView(
                WebView(htmlString: loadLegalHtmlString(kind: .dataPrivacy))
              )))
    }

    var imprintListItem: ListItem {
        .init(icon: .menuImprintIcon,
              title: L10n.Menu.Items.imprint,
              action: .presentedContent(AnyView(
                WebView(htmlString: loadImprintHtmlString())
              )))
    }

    var analyticsListItem: ListItem {
        .init(icon: .menuAnalyticsIcon,
              title: L10n.menuItemsAnalytics,
              action: .detail(destination: AnyView(
                MenuAnalyticsView(analyticsManager: analyticsManager)
                    .navigationTitle(L10n.menuItemsAnalytics)
              )))
    }

    var permissionsListItem: ListItem {
        .init(icon: .menuPermissionsIcon,
              title: L10n.menuItemsPermissions,
              action: .detail(destination: AnyView(
                MenuPermissionsView()
                    .navigationTitle(L10n.menuItemsPermissions)
              )))
    }
}

extension MenuViewModel: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction) async -> WKNavigationActionPolicy {
        guard let url = navigationAction.request.url else {
            return .allow
        }

        DispatchQueue.main.async {
            UIApplication.shared.open(url)
        }

        return .allow
    }
}
