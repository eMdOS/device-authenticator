import Foundation
import LocalAuthentication

public struct AuthenticationError: Error {
    public let code: Int
    public let type: AuthenticationErrorType

    init(error: LAError) {
        code = error.code.rawValue
        type = AuthenticationErrorType.from(code: code)
    }
}
