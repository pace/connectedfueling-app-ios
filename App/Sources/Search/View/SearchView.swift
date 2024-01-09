import SwiftUI

struct SearchView: View {
    @Environment(\.dismiss) private var dismiss: DismissAction
    @ObservedObject private var viewModel: SearchViewModel
    @State private var searchText: String = ""

    init(viewModel: SearchViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        AppNavigationView {
            searchContent
                .addNavigationBar(style: .centeredIcon(icon: .secondaryHeaderIcon))
                .navigationBarItems(trailing: Button(L10n.commonUseClose, action: {
                    dismiss()
                }))
                .accentColor(.genericBlack)
        }
    }

    @ViewBuilder
    private var searchContent: some View {
        VStack(spacing: 0) {
            searchField
                .padding(.all, .paddingM)
            if !viewModel.searchResults.isEmpty {
                Divider()
                    .overlay(Color.genericGrey)
                    .padding(.horizontal, .paddingM)
                resultsList
            }
            Spacer()
        }
    }

    @ViewBuilder
    private var searchField: some View {
        HStack {
            Image(.mapSearchIcon)
                .resizable()
                .frame(width: 32, height: 32)
                .padding(.leading, .paddingXXS)
            TextField(L10n.searchTitle, text: $searchText)
                .font(.system(size: 20))
                .foregroundStyle(Color.genericBlack)
                .tint(Color.genericBlack)
                .padding(.trailing, .paddingXXS)
                .submitLabel(.search)
                .onChange(of: searchText) { newText in
                    viewModel.completeSearch(for: newText)
                }
                .onSubmit {
                    guard !searchText.isEmpty else { return }
                    viewModel.search(for: searchText)
                }
        }
        .frame(maxWidth: .infinity, minHeight: 50)
        .background(Color.lightGrey)
        .cornerRadius(.cornerRadius)
    }

    @ViewBuilder
    private var resultsList: some View {
        List(viewModel.searchResults, id: \.self) { searchResult in
            Button(action: {
                viewModel.search(for: searchResult)
            }, label: {
                VStack(alignment: .leading, spacing: .paddingXXXS) {
                    TextLabel(searchResult.title, alignment: .leading)
                        .font(.system(size: 16, weight: .bold))
                    TextLabel(searchResult.subtitle, textColor: .genericGrey, alignment: .leading)
                        .font(.system(size: 12))
                }
            })
            .listRowSeparatorTint(.genericGrey)
            .padding(.vertical, .paddingXXXS)
        }
        .listStyle(.plain)
    }
}

#Preview {
    SearchView(viewModel: .init(region: .init(), onSearch: { _ in }))
}
