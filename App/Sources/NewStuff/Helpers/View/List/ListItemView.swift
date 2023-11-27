import SwiftUI

struct ListItemView: View {
    private let listItem: ListItem
    @State private var isPresentingContent: Bool = false

    init(listItem: ListItem) {
        self.listItem = listItem
    }

    var body: some View {
        HStack(spacing: 0) {
            Image(listItem.icon)
                .frame(width: 19, height: 19, alignment: .center)
                .padding(.trailing, .paddingXS)
            switch listItem.action {
            case .presentedContent(let content):
                appPresentationContent
                    .sheet(isPresented: $isPresentingContent) {
                        content
                    }

            case .detail(let destination):
                detailContent(with: destination)
            }
            Spacer()
            DisclosureIndicator()
        }
    }

    @ViewBuilder
    private var titleLabel: some View {
        TextLabel(listItem.title)
            .font(.system(size: 16, weight: .medium))
    }

    @ViewBuilder
    private var appPresentationContent: some View {
        Button {
            isPresentingContent = true
        } label: {
            titleLabel
        }
    }

    @ViewBuilder
    private func detailContent(with destination: some View) -> some View {
        ZStack(alignment: .leading) {
            NavigationLink(destination: destination) {
                EmptyView()
            }.opacity(0)
            titleLabel
        }
    }
}

#Preview {
    AppNavigationView {
        VStack {
            ListItemView(listItem: .init(icon: .walletTabIcon,
                                         title: "Item 1",
                                         action: .detail(destination: AnyView(Text("Hello")))))
            ListItemView(listItem: .init(icon: .walletTabIcon,
                                         title: "Item 2",
                                         action: .presentedContent(AnyView(Text("Hello")))))
        }
        .addNavigationBar(style: .standard(title: "List"))
    }
}
