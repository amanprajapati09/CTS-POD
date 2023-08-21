//
//  SignInClient.swift
//  CTS POD
//
//  Created by jayesh kanzariya on 21/08/23.
//

import Foundation
protocol SignInClientProtocol {
    func signIn(username: String, password: String, completion: @escaping (Result<CustomerResult, Error>)->()) async throws -> Void
}

final class SignInClient: SignInClientProtocol {
    
    enum Endpoint: EndpointConfiguration {
       
        case signIn(username: String, password: String)
        
        var path: String {
            return Constant.baseURL + " /User/"
        }
        
        var method: RequestMethods { return .GET }
        
        var body: Encodable? {
            return nil
        }
        
        var queryParam: [URLQueryItem]? {
            switch self {
            case .signIn(let username, let password):
                return [URLQueryItem(name: "domain", value: username)]
            }
        }
    }
    
    func signIn(username: String, password: String, completion: @escaping (Result<CustomerResult, Error>)->()) async throws -> Void {
        let configuration = SignInClient.Endpoint.signIn(username: username, password: password)
        let request = try URLRequest.init(endpoint: configuration)
        _ = APIClient.sharedObject.load(urlRequest: request, completion: completion)
    }
}

