

import Foundation
protocol SignInClientProtocol {
    func signIn(loginRequest: LoginRequestModel, completion: @escaping (Result<LoginResponse, Error>)->()) async throws -> Void
    func generateOTP(forgotPasswordRequest: ForgotPasswordRequest, completion: @escaping(Result<ForgotPasswordResponse, Error>)->())  async throws -> Void
    func validateOTP(validateOTPRequest: ValidateOTPRequest, completion: @escaping(Result<ForgotPasswordResponse, Error>)->())  async throws -> Void
}

final class SignInClient: SignInClientProtocol {
    
    enum Endpoint: EndpointConfiguration {
       
        case signIn(LoginRequestModel)
        case generateOTP(ForgotPasswordRequest)
        case validateOTP(ValidateOTPRequest)
        
        var path: String {
            switch self {
            case .signIn: return Constant.baseURL + "User/LogIn"
            case .generateOTP: return Constant.baseURL + "User/GenerateOTPAPI"
            case .validateOTP: return Constant.baseURL + "User/ValidateOTPAPI"
            }
            
        }
         
        var method: RequestMethods { return .POST }
        
        var body: Encodable? {
            switch self {
            case .signIn(let request):
                return request.loginRequest
            case .generateOTP(let request):
                return request
            case .validateOTP(let request):
                return request
            }
        }
        
        var queryParam: [URLQueryItem]? {
            return nil
        }
    }
    
    func signIn(loginRequest: LoginRequestModel, completion: @escaping (Result<LoginResponse, Error>)->()) async throws -> Void {
        let configuration = SignInClient.Endpoint.signIn(loginRequest)
        var request = try URLRequest.init(endpoint: configuration)
        request.setValue(loginRequest.deviceID, forHTTPHeaderField: "deviceID")
        request.setValue(loginRequest.apiClient, forHTTPHeaderField: "apiClient")
        request.setValue(loginRequest.appVersion, forHTTPHeaderField: "appVersion")
        request.setValue(loginRequest.version, forHTTPHeaderField: "version")
        _ = APIClient.sharedObject.load(urlRequest: request, completion: completion)
    }
    
    func generateOTP(forgotPasswordRequest: ForgotPasswordRequest, completion: @escaping(Result<ForgotPasswordResponse, Error>)->())  async throws -> Void {
        let configuration = SignInClient.Endpoint.generateOTP(forgotPasswordRequest)
        var request = try URLRequest.init(endpoint: configuration)
        _ = APIClient.sharedObject.load(urlRequest: request, completion: completion)
    }
    
    func validateOTP(validateOTPRequest: ValidateOTPRequest, completion: @escaping(Result<ForgotPasswordResponse, Error>)->())  async throws -> Void {
        let configuration = SignInClient.Endpoint.validateOTP(validateOTPRequest)
        var request = try URLRequest.init(endpoint: configuration)
        _ = APIClient.sharedObject.load(urlRequest: request, completion: completion)
    }
}

