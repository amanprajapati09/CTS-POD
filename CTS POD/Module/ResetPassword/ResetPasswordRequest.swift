
import Foundation

struct ResetPasswordRequest: Encodable {
    let uid: String
    let newPassword: String
    let newConfirmPassword: String
}
    
struct ResetPasswordResponse: Codable {
    let status, message: String
}
