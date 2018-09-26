
import Foundation

public protocol BiometricAuthenticatorType: class {
    var isAvailable: Bool { get }
    var biometricType: BiometricType { get }
    func authenticate(onSuccess: (() -> Void)?, onError: ((Swift.Error) -> Void)?)
}
