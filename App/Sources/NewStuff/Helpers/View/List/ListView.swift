import SwiftUI

struct ListView: View {
    private let listItems: [ListItem]

    init(listItems: [ListItem]) {
        self.listItems = listItems
    }

    var body: some View {
        List(listItems) { listItem in
            ListItemView(listItem: listItem)
        }
        .listStyle(.plain)
    }
}

#Preview {
    NavigationView {
        ListView(listItems: [
            .init(icon: .walletTabIcon,
                  title: "Item 1",
                  action: .detail(destination: AnyView(Text("Hello")))),
            .init(icon: .walletTabIcon,
                  title: "Item 2",
                  action: .presentedContent(AnyView(Text("Hello"))))
        ])
        .addNavigationBar()
    }
}
