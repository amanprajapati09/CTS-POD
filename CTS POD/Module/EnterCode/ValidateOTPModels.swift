
import Foundation

struct ValidateOTPRequest: Encodable {
    let userName: String
    let customerDomain: String
    let generatedOTP: String
}
