import PACECloudSDK
import SwiftUI

class MenuViewModel: ObservableObject {
    @Published private(set) var listItems: [ListItem] = []

    private let crashReportingManager: CrashReportingManager

    init(crashReportingManager: CrashReportingManager = .init()) {
        self.crashReportingManager = crashReportingManager

        listItems = [
            termsListItem,
            dataPrivacyListItem,
            imprintListItem
        ]

        addCustomMenuEntries()
    }

    private func addCustomMenuEntries() {
        guard let menuEntries = ConfigurationManager.configuration.menuEntries else { return }

        let languageCode = SystemManager.languageCode
        let customListItems: [ListItem] = menuEntries.compactMap { menuEntry in
            let menuItems = menuEntry.menuItems

            guard let menuItem = menuItems.first(where: { $0.languageCode == languageCode }) ??
                    menuItems.first(where: { $0.languageCode == Constants.fallbackLanguageCode })
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

            let listItem: ListItem = .init(icon: .externalSiteIcon,
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
        NSLog(message)
        crashReportingManager.sendEvent(level: .warning, message: message, parameters: nil)
    }
}

private extension MenuViewModel {
    var termsListItem: ListItem {
        .init(icon: .termsIcon,
              title: L10n.Menu.Items.terms,
              action: .presentedContent(AnyView(
                WebView(htmlString: loadLegalHtmlString(fileName: Constants.File.terms))
              )))
    }

    var dataPrivacyListItem: ListItem {
        .init(icon: .dataPrivacyIcon,
              title: L10n.Menu.Items.privacy,
              action: .presentedContent(AnyView(
                WebView(htmlString: loadLegalHtmlString(fileName: Constants.File.dataPrivacy))
              )))
    }

    var imprintListItem: ListItem {
        .init(icon: .imprintIcon,
              title: L10n.Menu.Items.imprint,
              action: .presentedContent(AnyView(
                WebView(htmlString: loadLegalHtmlString(fileName: Constants.File.imprint))
              )))
    }
}
