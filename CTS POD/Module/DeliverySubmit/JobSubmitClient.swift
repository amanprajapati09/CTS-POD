
import Foundation

protocol JobSubmitClientProtocol {
    func updateJobStatus(requestModel: JobSubmitRequest, completion: @escaping (Result<JobStatusUpdateResponse, Error>)->()) async throws -> Void
}

final class JobSubmitClient: JobSubmitClientProtocol {
    
    enum Endpoint: EndpointConfiguration {
        case updateState(JobSubmitRequest)
        
        var path: String {
            switch self {
            case .updateState: return Constant.baseURL + "Job/AddOrUpdateJobDocument"
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
    
    func updateJobStatus(requestModel: JobSubmitRequest, completion: @escaping (Result<JobStatusUpdateResponse, Error>) -> ()) async throws {
        let configuration =  JobSubmitClient.Endpoint.updateState(requestModel)
        let request = try URLRequest.init(endpoint: configuration)
        _ = APIClient.sharedObject.load(urlRequest: request, completion: completion)
    }
}
