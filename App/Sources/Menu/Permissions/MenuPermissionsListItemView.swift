import SwiftUI

struct MenuPermissionsListItemView: View {
    private let icon: ImageResource
    private let title: String
    private let description: String
    private var isOn: Bool
    private let onTap: (Bool) -> Void

    init(icon: ImageResource,
         title: String,
         description: String,
         isOn: Bool,
         onTap: @escaping (Bool) -> Void) {
        self.icon = icon
        self.title = title
        self.description = description
        self.isOn = isOn
        self.onTap = onTap
    }

    var body: some View {
        HStack(spacing: 0) {
            ListItemIconView(icon)
                .padding(.trailing, .paddingXS)
            VStack(alignment: .leading, spacing: 0) {
                TextLabel(title)
                    .font(.system(size: 16, weight: .bold))
                TextLabel(description, textColor: .genericGrey, alignment: .leading)
                    .font(.system(size: 14, weight: .regular))
            }
            Spacer()
            Switch(isOn: isOn) { newValue in
                onTap(newValue)
            }
        }
    }
}

#Preview {
    List {
        MenuPermissionsListItemView(icon: .menuPermissionsNotificationsIcon,
                                    title: L10n.menuPermissionsNotificationsTitle,
                                    description: L10n.menuPermissionsNotificationsDescription,
                                    isOn: true,
                                    onTap: { _ in })
        MenuPermissionsListItemView(icon: .menuPermissionsLocationIcon,
                                    title: L10n.menuPermissionsLocationTitle,
                                    description: L10n.menuPermissionsLocationDescription,
                                    isOn: false,
                                    onTap: { _ in })
    }
    .listStyle(.plain)
}
