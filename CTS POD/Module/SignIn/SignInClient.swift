

import Foundation
protocol SignInClientProtocol {
    func signIn(loginRequest: LoginRequestModel, completion: @escaping (Result<LoginResponse, Error>)->()) async throws -> Void
    func generateOTP(forgotPasswordRequest: ForgotPasswordRequest, completion: @escaping(Result<ForgotPasswordResponse, Error>)->())  async throws -> Void
    func validateOTP(validateOTPRequest: ValidateOTPRequest, completion: @escaping(Result<ForgotPasswordResponse, Error>)->())  async throws -> Void
    func resetPassword(resetPassword: ResetPasswordRequest, completion: @escaping(Result<ResetPasswordResponse, Error>)->())  async throws -> Void
}

final class SignInClient: SignInClientProtocol {
    
    enum Endpoint: EndpointConfiguration {
       
        case signIn(LoginRequestModel)
        case generateOTP(ForgotPasswordRequest)
        case validateOTP(ValidateOTPRequest)
        case resetPassword(ResetPasswordRequest)
        
        var path: String {
            switch self {
            case .signIn: return Constant.baseURL + "User/LogIn"
            case .generateOTP: return Constant.baseURL + "User/GenerateOTPAPI"
            case .validateOTP: return Constant.baseURL + "User/ValidateOTPAPI"
            case .resetPassword: return Constant.baseURL + "User/ResetPassword"
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
            case .resetPassword(let request):
                return request
            }
        }
        
        var queryParam: [URLQueryItem]? {
            return nil
        }
        
        var header: [String : String] {
            return  ["apiclient": "2",
                     "appversion":"1",
                     "deviceId":Constant.deviceID,
                     "version": "1"]
        }
    }
    
    func signIn(loginRequest: LoginRequestModel, completion: @escaping (Result<LoginResponse, Error>)->()) async throws -> Void {
        let configuration = SignInClient.Endpoint.signIn(loginRequest)
        let request = try URLRequest.init(endpoint: configuration)
        _ = APIClient.sharedObject.load(urlRequest: request, completion: completion)
    }
    
    func generateOTP(forgotPasswordRequest: ForgotPasswordRequest, completion: @escaping(Result<ForgotPasswordResponse, Error>)->())  async throws -> Void {
        let configuration = SignInClient.Endpoint.generateOTP(forgotPasswordRequest)
        let request = try URLRequest.init(endpoint: configuration)
        _ = APIClient.sharedObject.load(urlRequest: request, completion: completion)
    }
    
    func validateOTP(validateOTPRequest: ValidateOTPRequest, completion: @escaping(Result<ForgotPasswordResponse, Error>)->())  async throws -> Void {
        let configuration = SignInClient.Endpoint.validateOTP(validateOTPRequest)
        let request = try URLRequest.init(endpoint: configuration)      
        _ = APIClient.sharedObject.load(urlRequest: request, completion: completion)
    }
    
    func resetPassword(resetPassword: ResetPasswordRequest, completion: @escaping (Result<ResetPasswordResponse, Error>) -> ()) async throws {
        let configuration = SignInClient.Endpoint.resetPassword(resetPassword)
        let request = try URLRequest.init(endpoint: configuration)
        _ = APIClient.sharedObject.load(urlRequest: request, completion: completion)
    }
}

