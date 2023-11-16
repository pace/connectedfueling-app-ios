import SwiftUI

struct LoadingView: View {
    private let title: String
    private let description: String?

    init(title: String, description: String? = nil) {
        self.title = title
        self.description = description
    }

    var body: some View {
        content
            .background(BackgroundContainer())
    }

    @ViewBuilder
    private var content: some View {
        VStack(spacing: 0) {
            LoadingSpinner()
            TextLabel(title)
                .font(.system(size: 20, weight: .bold))
                .padding(.top, 15)
            if let description {
                TextLabel(description, textColor: .secondaryText)
                    .font(.system(size: 16))
                    .padding(.top, 15)
            }
        }
        .frame(minWidth: 0, maxWidth: .infinity)
        .padding(.all, 15)
    }
}

#Preview {
    LoadingView(title: "Loading Stuff", description: "Some description")
}
