import Foundation
import LocalAuthentication

public class BiometricAuthenticator {
    let policy: LAPolicy
    private(set) var authenticationContext: BiometricAuthenticationContext = LAContext() {
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
        @unknown default:
            fatalError()
        }
    }

    public func authenticate(localizedReason: String, result: @escaping (Result<Void, AuthenticationError>) -> Void) {
        if canEvaluatePolicy {
            authenticationContext.evaluatePolicy(policy, localizedReason: localizedReason) { (isSuccess, error) in
                if let error = error {
                    DispatchQueue.main.async(execute: {
                        result(.failure(AuthenticationError(error: LAError(_nsError: error as NSError))))
                    })
                } else if isSuccess {
                    DispatchQueue.main.async(execute: {
                        result(.success(()))
                    })
                }
            }
        } else if let error = authenticationError {
            DispatchQueue.main.async(execute: {
                result(.failure(AuthenticationError(error: LAError(_nsError: error))))
            })
        }
    }
}
