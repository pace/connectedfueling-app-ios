import SwiftUI

struct MenuAnalyticsStateView: View {
    @Binding private var isAnalyticsAllowed: Bool

    init(isAnalyticsAllowed: Binding<Bool>) {
        self._isAnalyticsAllowed = isAnalyticsAllowed
    }

    var body: some View {
        HStack(spacing: 5) {
            Image(isAnalyticsAllowed ? .checkIcon : .blockIcon)
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
                .foregroundColor(Color.genericWhite)
                .frame(width: 16, height: 16)
            TextLabel(isAnalyticsAllowed ? L10n.analyticsAcceptedText : L10n.analyticsDeclinedText, textColor: Color.genericWhite)
                .font(.system(size: 14, weight: .bold))
        }
        .padding(.all, .paddingXXS)
        .background(isAnalyticsAllowed ? Color.genericGreen : .genericRed)
        .cornerRadius(52)
    }
}

#Preview {
    VStack {
        MenuAnalyticsStateView(isAnalyticsAllowed: .constant(true))
        MenuAnalyticsStateView(isAnalyticsAllowed: .constant(false))
    }
}
