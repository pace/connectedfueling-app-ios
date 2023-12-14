import SwiftUI

struct MenuView: View {
    @StateObject private var viewModel: MenuViewModel = .init()

    var body: some View {
        VStack(spacing: 0) {
            ListView(listItems: viewModel.listItems)
        }
    }
}

#Preview {
    MenuView()
}
