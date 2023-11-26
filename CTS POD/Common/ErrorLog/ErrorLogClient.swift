//
//  ErrorLogClient.swift
//  CTS POD
//
//  Created by Aman Prajapati on 25/11/23.
//

import Foundation

protocol ErrorLogClientProtocol {
    func logError(requestModel: ErrorLogReqModel, completion: @escaping (Result<JobStatusUpdateResponse, Error>)->()) async throws -> Void
}

final class ErrorLogClient: ErrorLogClientProtocol {
        
    enum Endpoint: EndpointConfiguration {
        case logError(ErrorLogReqModel)
        
        var path: String {
            switch self {
            case .logError: return Constant.baseURL + "ErrorLog/Post"
            }
        }
        
        var method: RequestMethods {
            switch self {
            case .logError: return .POST
            }
        }
        
        var body: Encodable? {
            switch self {
            case .logError(let request): return request
            }
        }
        
        var queryParam: [URLQueryItem]? {
            return nil
        }
        
        var header: [String : String] {
            if let user = LocalTempStorage.getValue(fromUserDefault: LoginDetails.self, key: UserDefaultKeys.user) {
                return ["Authorization": user.token.authToken]
            }
            return [:]
        }
    }
    
    func logError(requestModel: ErrorLogReqModel, completion: @escaping (Result<JobStatusUpdateResponse, Error>) -> ()) async throws {
        let configuration =  ErrorLogClient.Endpoint.logError(requestModel)
        var request = try URLRequest.init(endpoint: configuration)        
        _ = APIClient.sharedObject.load(urlRequest: request, completion: completion)
    }
}
