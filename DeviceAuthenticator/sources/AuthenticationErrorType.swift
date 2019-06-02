import Foundation
import LocalAuthentication

public enum AuthenticationErrorType: CaseIterable {
    case biometricNotEnrolled
    case biometricNotAvailable
    case biometricLockout

    case systemCancel
    case appCancel
    case userCancel

    case authenticationFailed
    case passcodeNotSet
    case userFallback

    case invalidContext
    case notInteractive

    case unknown
}

extension AuthenticationErrorType {
    static func from(code: Int) -> AuthenticationErrorType {
        switch code {
        case LAError.biometryNotEnrolled.rawValue:
            return .biometricNotEnrolled
        case LAError.biometryNotAvailable.rawValue:
            return .biometricNotAvailable
        case LAError.biometryLockout.rawValue:
            return .biometricLockout

        case LAError.systemCancel.rawValue:
            return .systemCancel
        case LAError.appCancel.rawValue:
            return .appCancel
        case LAError.userCancel.rawValue:
            return .userCancel

        case LAError.authenticationFailed.rawValue:
            return .authenticationFailed
        case LAError.passcodeNotSet.rawValue:
            return .passcodeNotSet
        case LAError.userFallback.rawValue:
            return .userFallback

        case LAError.invalidContext.rawValue:
            return .invalidContext
        case LAError.notInteractive.rawValue:
            return .notInteractive

        default:
            return .unknown
        }
    }
}
