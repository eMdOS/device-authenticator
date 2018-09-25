
import Foundation
import LocalAuthentication

public class BiometricAuthenticator {

    let policy: LAPolicy
    let authenticationContext: LAContext = LAContext()
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
    public var biometricType: BiometricType {
        switch authenticationContext.biometryType {
        case .none: return .none
        case .touchID: return .touchID
        case .faceID: return .faceID
        }
    }
}
