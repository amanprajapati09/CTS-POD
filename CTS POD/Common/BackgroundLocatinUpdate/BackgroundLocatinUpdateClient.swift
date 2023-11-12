import Foundation

protocol BackgroundLocatinUpdateClientProtocol {
    func updateLocation(requestModel: BackgroundLocatinUpdateRequest, completion: @escaping (Result<BackgroundLocatinUpdateResponse, Error>)->()) async throws -> Void
}

final class BackgroundLocatinUpdateClient: BackgroundLocatinUpdateClientProtocol {
    
    enum Endpoint: EndpointConfiguration {
        case locationPost(BackgroundLocatinUpdateRequest)
        
        var path: String {
            switch self {
            case .locationPost: return Constant.baseURL + "Device/Post"
            }
        }
        
        var method: RequestMethods {
            switch self {
            case .locationPost: return .POST
            }
        }
        
        var body: Encodable? {
            switch self {
            case .locationPost(let request): return request
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
    
    func updateLocation(requestModel: BackgroundLocatinUpdateRequest, completion: @escaping (Result<BackgroundLocatinUpdateResponse, Error>) -> ()) async throws {
        let configuration =  BackgroundLocatinUpdateClient.Endpoint.locationPost(requestModel)
        let request = try URLRequest.init(endpoint: configuration)
        _ = APIClient.sharedObject.load(urlRequest: request, completion: completion)
    }
}
