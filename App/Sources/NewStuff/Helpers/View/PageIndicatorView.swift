import SwiftUI

struct PageIndicatorView: View {
    @Binding private var selectedIndex: Int
    let numberOfPages: Int

    private let dashWidth: CGFloat = 40
    private let dashHeight: CGFloat = 3
    private let dashCornerRadius: CGFloat = 1.5
    private let dashSpacing: CGFloat = 10
    private let primaryColor = Color.lightGrey
    private let secondaryColor = Color.genericGrey

    init(numberOfPages: Int, selectedIndex: Binding<Int>) {
        self.numberOfPages = numberOfPages
        self._selectedIndex = selectedIndex
    }

    var body: some View {
        HStack(spacing: dashSpacing) {
            ForEach(0..<numberOfPages, id: \.self) { index in
                Rectangle()
                    .fill(selectedIndex == index ? primaryColor : secondaryColor)
                    .frame(width: dashWidth, height: dashHeight)
                    .id(index)
            }
        }
    }
}

#Preview {
    PageIndicatorView(numberOfPages: 5, selectedIndex: .constant(3))
}
