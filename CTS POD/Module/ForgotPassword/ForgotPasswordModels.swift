
import Foundation

struct ForgotPasswordRequest: Encodable {
    let userName: String
    let customerDomain: String
}

struct ForgotPasswordResponse: Codable {
    let status, message: String
    let data: ForgotPasswordDataClass?
}

struct ForgotPasswordDataClass: Codable {
    let otp: OTP?

    enum CodingKeys: String, CodingKey {
        case otp = "OTP"
    }
}

struct OTP: Codable {
    let otpID, generatedOTP, createdDate, userID: String

    enum CodingKeys: String, CodingKey {
        case otpID = "otpId"
        case generatedOTP, createdDate
        case userID = "userId"
    }
}
