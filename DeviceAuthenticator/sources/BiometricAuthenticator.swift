
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

    public func authenticate(onSuccess: (() -> Void)?, onError: ((Error) -> Void)?) {
        if canEvaluatePolicy {
            authenticationContext.evaluatePolicy(policy, localizedReason: "Localized Reason") { (isSuccess, error) in
                if let error = error {
                    onError?(error)
                } else if isSuccess {
                    onSuccess?()
                }
            }
        } else if let error = authenticationError {
            onError?(error)
        }
    }
}
