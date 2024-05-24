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
                .padding(.top, .paddingS)
            if let description {
                TextLabel(description)
                    .font(.system(size: 16))
                    .padding(.horizontal, .paddingM)
                    .padding(.top, .paddingS)
            }
        }
        .frame(minWidth: 0, maxWidth: .infinity)
        .padding(.all, .paddingS)
    }
}

#Preview {
    LoadingView(title: "Loading Stuff", description: "Some description")
}
