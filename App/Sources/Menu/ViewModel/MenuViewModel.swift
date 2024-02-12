import PACECloudSDK
import SwiftUI

class MenuViewModel: ObservableObject {
    @Published private(set) var listItems: [ListItem] = []

    private let crashReportingManager: CrashReportingManager
    private let analyticsManager: AnalyticsManager

    init(crashReportingManager: CrashReportingManager = .shared,
         analyticsManager: AnalyticsManager,
         configuration: ConfigurationManager.Configuration = ConfigurationManager.configuration) {
        self.crashReportingManager = crashReportingManager
        self.analyticsManager = analyticsManager

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

            guard let url = URL(string: menuItem.url) else {
                let errorMessage = "[MenuViewModel] URL string \(menuItem.url) of menu item \(menuItem.name) for language \(menuItem.languageCode) is not a valid URL."
                logError(errorMessage)
                return nil
            }

            let listItem: ListItem = .init(icon: .menuExternalSiteIcon,
                                           title: menuItem.name,
                                           action: .presentedContent(AnyView(
                                            SafariView(url: url)
                                                .ignoresSafeArea()
                                           )))
            return listItem
        }

        self.listItems += customListItems
    }

    private func loadLegalHtmlString(fileName: String) -> String {
        SystemManager.loadHTMLFromBundle(fileName: fileName)
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
                WebView(htmlString: loadLegalHtmlString(fileName: Constants.File.termsOfUse))
              )))
    }

    var dataPrivacyListItem: ListItem {
        .init(icon: .menuDataPrivacyIcon,
              title: L10n.Menu.Items.privacy,
              action: .presentedContent(AnyView(
                WebView(htmlString: loadLegalHtmlString(fileName: Constants.File.dataPrivacy))
              )))
    }

    var imprintListItem: ListItem {
        .init(icon: .menuImprintIcon,
              title: L10n.Menu.Items.imprint,
              action: .presentedContent(AnyView(
                WebView(htmlString: loadLegalHtmlString(fileName: Constants.File.imprint))
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
