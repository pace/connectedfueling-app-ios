import Foundation

enum OnboardingTextInputResponseType {
    case biometry(otp: String)
    case pin(pin: String, otp: String)
}
