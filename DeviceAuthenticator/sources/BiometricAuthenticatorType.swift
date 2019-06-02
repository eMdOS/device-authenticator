import Foundation

public protocol BiometricAuthenticatorType: class {
    var isAvailable: Bool { get }
    var biometricType: BiometricType { get }
    func authenticate(localizedReason: String, result: @escaping (Result<Void, AuthenticationError>) -> Void)
}
