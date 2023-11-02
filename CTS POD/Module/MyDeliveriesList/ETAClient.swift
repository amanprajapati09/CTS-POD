import Foundation

protocol ETAClientProtocol {
    func updateETAStatus(requestModel: ETAReuqest, completion: @escaping (Result<JobStatusUpdateResponse, Error>)->()) async throws -> Void
}

final class ETAClient: ETAClientProtocol {
    
    enum Endpoint: EndpointConfiguration {
        case updateState(ETAReuqest)
        
        var path: String {
            switch self {
            case .updateState: return Constant.baseURL + "Job/SendETA"
            }
        }
        
        var method: RequestMethods {
            switch self {
            case .updateState: return .POST
            }
        }
        
        var body: Encodable? {
            switch self {            
            case .updateState(let request): return request
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
    
    func updateETAStatus(requestModel: ETAReuqest, completion: @escaping (Result<JobStatusUpdateResponse, Error>) -> ()) async throws {
        let configuration =  ETAClient.Endpoint.updateState(requestModel)
        let request = try URLRequest.init(endpoint: configuration)
        _ = APIClient.sharedObject.load(urlRequest: request, completion: completion)
    }
}
