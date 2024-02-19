import SwiftUI

struct MenuPermissionsView: View {
    @Environment(\.scenePhase) private var scenePhase
    @ObservedObject private var viewModel: MenuPermissionsViewModel

    init(viewModel: MenuPermissionsViewModel = .init()) {
        self.viewModel = viewModel
    }

    var body: some View {
        content
            .onChange(of: scenePhase) { newPhase in
                guard newPhase == .active else { return }
                viewModel.refreshPermissions()
            }
            .alert(item: $viewModel.alert) { alert in
                alert
            }
    }

    @ViewBuilder
    private var content: some View {
        List {
            if viewModel.showsNotificationSetting {
                MenuPermissionsListItemView(icon: .menuPermissionsNotificationsIcon,
                                            title: L10n.menuPermissionsNotificationsTitle,
                                            description: L10n.menuPermissionsNotificationsDescription,
                                            isOn: viewModel.isNotificationsEnabled,
                                            onTap: viewModel.didTapNotificationSetting(newValue:))
            }
            MenuPermissionsListItemView(icon: .menuPermissionsLocationIcon,
                                        title: L10n.menuPermissionsLocationTitle,
                                        description: L10n.menuPermissionsLocationDescription,
                                        isOn: viewModel.isLocationEnabled,
                                        onTap: viewModel.didTapLocationSetting(newValue:))
        }
        .listStyle(.plain)
    }
}

#Preview {
    MenuPermissionsView()
}
