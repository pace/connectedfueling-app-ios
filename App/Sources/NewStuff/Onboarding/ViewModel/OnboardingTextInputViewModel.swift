import Foundation

class OnboardingTextInputViewModel: ObservableObject, Identifiable {
    @Published var isActionDisabled: Bool = true
    @Published var isNextTextInputViewPresented: Bool = false
    @Published var warningText: String = ""
    @Published var isErrorAlertPresented: Bool = false

    let title: String
    let description: String
    let actionTitle: String
    let isInputSecure: Bool
    let numberOfDigitsRequired: Int
    let nextTextInputViewModel: OnboardingTextInputViewModel?

    let type: OnboardingTextInputType
    private var previousTextInput: String?
    private let completion: (OnboardingTextInputResponseType) -> Void
    private let userManager: UserManager

    init(type: OnboardingTextInputType,
         completion: @escaping (OnboardingTextInputResponseType) -> Void,
         userManager: UserManager = .init()) {
        self.type = type
        self.completion = completion
        self.userManager = userManager

        switch type {
        case .biometryOTP, .pinOTP:
            title = L10n.Onboarding.EnterOneTimePassword.title
            description = L10n.Onboarding.EnterOneTimePassword.description
            actionTitle = L10n.Onboarding.EnterOneTimePassword.confirm
            isInputSecure = false
            numberOfDigitsRequired = Constants.otpDigitsCount
            nextTextInputViewModel = nil

        case .pin:
            title = L10n.Onboarding.CreatePin.title
            description = L10n.Onboarding.CreatePin.description
            actionTitle = L10n.Onboarding.CreatePin.confirm
            isInputSecure = true
            numberOfDigitsRequired = Constants.pinDigitsCount
            nextTextInputViewModel = .init(type: .pinConfirmation, completion: completion)

        case .pinConfirmation:
            title = L10n.Onboarding.VerifyPin.title
            description = L10n.Onboarding.VerifyPin.description
            actionTitle = L10n.Onboarding.VerifyPin.confirm
            isInputSecure = true
            numberOfDigitsRequired = Constants.pinDigitsCount
            nextTextInputViewModel = .init(type: .pinOTP, completion: completion)
        }
    }

    func didTapActionButton(textInput: String) {
        switch type {
        case .biometryOTP:
            completion(.biometry(otp: textInput))

        case .pinOTP:
            guard let previousTextInput else { return }
            completion(.pin(pin: previousTextInput, otp: textInput))

        case .pin:
            nextTextInputViewModel?.previousTextInput = textInput
            isNextTextInputViewPresented = true

        case .pinConfirmation:
            requestMailOTPForPIN()
            nextTextInputViewModel?.previousTextInput = textInput
            isNextTextInputViewPresented = true
        }
    }

    // swiftlint:disable switch_case_alignment
    func onEditingChanged(of input: String) {
        switch type {
        case .pin:
            warningText = switch PINInputValidator.validate(pin: input) {
            case .success:
                ""

            case .failure(let validationError):
                switch validationError {
                case .empty:
                    ""

                case .repetition:
                    L10n.Onboarding.Pin.Error.tooFewDigits

                case .invalidLength:
                    L10n.Onboarding.Pin.Error.invalidLength

                case .consecutiveOrder:
                    L10n.Onboarding.Pin.Error.series
                }
            }

        case .pinConfirmation:
            warningText = if !input.isEmpty && input != previousTextInput {
                L10n.Onboarding.Pin.Error.mismatch
            } else {
                ""
            }

        default:
            break
        }

        isActionDisabled = input.count != numberOfDigitsRequired || !warningText.isEmpty
    }

    private func requestMailOTPForPIN() {
        Task { @MainActor [weak self] in
            guard let result = await self?.userManager.sendMailOTP() else { return }

            switch result {
            case .success(let didSendMailOTP):
                guard didSendMailOTP else {
                    NSLog("[OnboardingTextInputViewModel] Failed sending mail OTP")
                    self?.isErrorAlertPresented = true
                    return
                }

                NSLog("[OnboardingTextInputViewModel] Successfully sent mail OTP")

            case .failure(let error):
                NSLog("[OnboardingTextInputViewModel] Failed sending mail OTP with \(error)")
                self?.isErrorAlertPresented = true
            }
        }
    }
}
