import SwiftUI

struct MenuView: View {
    @StateObject private var viewModel: MenuViewModel

    init(analyticsManager: AnalyticsManager) {
        self._viewModel = .init(wrappedValue: .init(analyticsManager: analyticsManager))
    }

    var body: some View {
        VStack(spacing: 0) {
            ListView(listItems: viewModel.listItems)
        }
    }
}

#Preview {
    MenuView(analyticsManager: .init())
}
