import Combine
import Foundation

@MainActor
class SingleDigitTextFieldGroupViewModel: ObservableObject {
    @Published var inputs: [String]
    @Published var isValid: Bool = false
    @Published var selectedTextFieldIndex: Int

    var input: String {
        inputs.joined()
    }

    let numberOfDigits: Int

    init(numberOfDigits: Int) {
        self.numberOfDigits = numberOfDigits
        self.inputs = Array(repeating: "", count: numberOfDigits)
        self.selectedTextFieldIndex = 0
    }
}
