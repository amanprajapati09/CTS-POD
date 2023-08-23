

import Foundation
protocol SignInClientProtocol {
    func signIn(loginRequest: LoginRequestModel, completion: @escaping (Result<LoginResponse, Error>)->()) async throws -> Void
}

final class SignInClient: SignInClientProtocol {
    
    enum Endpoint: EndpointConfiguration {
       
        case signIn(LoginRequestModel)
        
        var path: String {
            return Constant.baseURL + "User/LogIn"
        }
         
        var method: RequestMethods { return .POST }
        
        var body: Encodable? {
            switch self {
            case .signIn(let request):
                return request.loginRequest
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
}

