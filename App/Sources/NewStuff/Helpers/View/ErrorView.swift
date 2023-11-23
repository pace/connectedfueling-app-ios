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
                .foregroundStyle(Color.red)
                .frame(width: 40, height: 40)
            TextLabel(error.title)
                .font(.system(size: 20, weight: .bold))
                .padding(.top, 15)
            if let description = error.description {
                TextLabel(description, textColor: .genericGrey)
                    .font(.system(size: 16))
                    .padding(.top, 15)
            }
            if let retryAction = error.retryAction {
                ActionButton(title: retryAction.title,
                             action: retryAction.action)
                .padding(.top, 15)
            }
        }
        .frame(minWidth: 0, maxWidth: .infinity)
        .padding(.all, 15)
    }

    @ViewBuilder
    private var icon: some View {
        switch error.icon {
        case .imageResource(let imageResource):
            Image(imageResource)

        case .image(let image):
            image
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
