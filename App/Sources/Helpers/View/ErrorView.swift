import SwiftUI

struct ErrorView: View {
    private let error: AppError

    init(_ error: AppError) {
        self.error = error
    }

    var body: some View {
        content
            .background(BackgroundContainer())
    }

    @ViewBuilder
    private var content: some View {
        VStack(spacing: 0) {
            icon
                .foregroundStyle(Color.genericRed)
                .frame(width: 40, height: 40)
            TextLabel(error.title)
                .font(.system(size: 20, weight: .bold))
                .padding(.top, .paddingXXS)
                .padding(.horizontal, .paddingM)
            if let description = error.description {
                TextLabel(description)
                    .font(.system(size: 16))
                    .padding(.top, .paddingXXS)
                    .padding(.horizontal, .paddingS)
            }
            if let retryAction = error.retryAction {
                ActionButton(title: retryAction.title,
                             action: retryAction.action)
                .padding(.top, .paddingXS)
            }
        }
        .frame(minWidth: 0, maxWidth: .infinity)
        .padding(.all, .paddingS)
    }

    @ViewBuilder
    private var icon: some View {
        switch error.icon {
        case .imageResource(let imageResource):
            Image(imageResource)
                .resizable()
                .scaledToFit()

        case .image(let image):
            image
                .resizable()
                .scaledToFit()
        }
    }
}

#Preview {
    VStack {
        ErrorView(.init(title: "Something went wrong"))
        ErrorView(.init(title: "Something went wrong",
                        description: "Some description"))
        ErrorView(.init(title: "Something went wrong",
                        description: "Some description",
                        icon: .imageResource(.noGasStationsIcon)))
        ErrorView(.init(title: "Something went wrong",
                        description: "Some description",
                        icon: .imageResource(.noGasStationsIcon),
                        retryAction: .init(title: "Try again",
                                           action: {})))
    }
}
