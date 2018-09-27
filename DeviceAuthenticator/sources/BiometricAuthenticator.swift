
import Foundation
import LocalAuthentication

public class BiometricAuthenticator {
    let policy: LAPolicy
    internal(set) var authenticationContext: BiometricAuthenticationContext = LAContext() {
        didSet {
            _ = canEvaluatePolicy
        }
    }
    private(set) var authenticationError: NSError?

    public init(shouldSupportPasscode: Bool = false) {
        policy = shouldSupportPasscode ? .deviceOwnerAuthentication : .deviceOwnerAuthenticationWithBiometrics
        _ = canEvaluatePolicy
    }

    var canEvaluatePolicy: Bool {
        return authenticationContext.canEvaluatePolicy(policy, error: &authenticationError)
    }
}

// MARK: - BiometricAuthenticatorType

extension BiometricAuthenticator: BiometricAuthenticatorType {
    public var isAvailable: Bool {
        return biometricType != .none
    }

    public var biometricType: BiometricType {
        switch authenticationContext.biometryType {
        case .none: return .none
        case .touchID: return .touchID
        case .faceID: return .faceID
        }
    }

    public func authenticate(onSuccess: (() -> Void)?, onError: ((AuthenticationError) -> Void)?) {
        if canEvaluatePolicy {
            authenticationContext.evaluatePolicy(policy, localizedReason: "Localized Reason") { (isSuccess, error) in
                if let error = error {
                    DispatchQueue.main.async(execute: {
                        onError?(AuthenticationError(error: LAError(_nsError: error as NSError)))
                    })
                } else if isSuccess {
                    DispatchQueue.main.async(execute: {
                        onSuccess?()
                    })
                }
            }
        } else if let error = authenticationError {
            DispatchQueue.main.async(execute: {
                onError?(AuthenticationError(error: LAError(_nsError: error)))
            })
        }
    }
}
