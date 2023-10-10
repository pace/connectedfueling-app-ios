import SwiftUI

struct PageView<Content>: View where Content: View {
    @Binding private var currentPage: Int

    let numberOfPages: Int
    let content: Content

    init(numberOfPages: Int,
         currentPage: Binding<Int>,
         @ViewBuilder content: () -> Content) {
        self.numberOfPages = numberOfPages
        self._currentPage = currentPage
        self.content = content()
    }

    var body: some View {
        GeometryReader { geometry in
            LazyHStack(spacing: 0) {
                content.frame(width: geometry.size.width)
            }
            .frame(width: geometry.size.width, alignment: .leading)
            .offset(x: -CGFloat(currentPage) * geometry.size.width)
            .animation(.default)
        }
    }
}
