
import Foundation

public protocol BiometricAuthenticatorType: class {
    var isAvailable: Bool { get }
    var biometricType: BiometricType { get }
    func authenticate(onSuccess: (() -> Void)?, onError: ((AuthenticationError) -> Void)?)
}
