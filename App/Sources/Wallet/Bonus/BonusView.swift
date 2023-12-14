import SwiftUI

struct BonusView: View {
    var body: some View {
        ScrollView {
            Image(.bonusFakePage)
                .resizable()
                .scaledToFit()
        }
    }
}

#Preview {
    BonusView()
}
