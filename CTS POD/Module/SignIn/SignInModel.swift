
import Foundation

struct LoginRequestModel {
    let apiClient = "2"
    let deviceID = Constant.deviceID
    let appVersion = "1"
    let version = "1"
    let loginRequest: LoginRequest
}

struct LoginRequest: Encodable {
    let userName, password, customerDomain: String
    let rememberMe = true
    let error = "String"
}

struct LoginResponse: Codable {
    let status, message: String
    let data: LoginDataClass?
}

// MARK: - DataClass
struct LoginDataClass: Codable {
    let loginDetails: LoginDetails?
    
    private enum CodingKeys: String, CodingKey {
        case loginDetails = "LoginDetails"
    }
}

struct LoginDetails: Codable {
    let id: String
    let user: User
    let token: Token
}

struct Token: Codable {
    let tokenType, autheticationToken: String
    private enum CodingKeys: String, CodingKey {
        case tokenType = "token_type"
        case autheticationToken = "authetication_token"
    }
}

struct User: Codable {
    let firstname, lastname, username, mobilenumber: String
    let timeInterval: Int
    let customerID: String
}
