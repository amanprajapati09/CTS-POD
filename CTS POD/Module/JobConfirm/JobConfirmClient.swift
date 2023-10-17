
import Foundation
protocol JobConfirmClientProtocol {
    func fetchJob(completion: @escaping (Result<JobConfirmResponse, Error>)->()) async throws -> Void
    func updateJob(request: JobStatusUpdate, completion: @escaping (Result<JobStatusUpdateResponse, Error>)->()) async throws -> Void
}

final class JobConfirmClient: JobConfirmClientProtocol {
    
    enum Endpoint: EndpointConfiguration {
        case fetchJob
        case updateState(JobStatusUpdate)
        
        var path: String {
            switch self {
            case .fetchJob: return Constant.baseURL + "Job/JobList"
            case .updateState: return Constant.baseURL + "Job/ChangeJobStatus"
            }
        }
        
        var method: RequestMethods {
            switch self {
            case .fetchJob: return .GET
            case .updateState: return .POST
            }
        }
        
        var body: Encodable? {
            switch self {
            case .fetchJob: return nil
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
    
    func fetchJob(completion: @escaping (Result<JobConfirmResponse, Error>) -> ()) async throws {
        let configuration =  JobConfirmClient.Endpoint.fetchJob
        let request = try URLRequest.init(endpoint: configuration)
        _ = APIClient.sharedObject.load(urlRequest: request, completion: completion)
    }
    
    func updateJob(request: JobStatusUpdate, completion: @escaping (Result<JobStatusUpdateResponse, Error>) -> ()) async throws {
        let configuration =  JobConfirmClient.Endpoint.updateState(request)
        let request = try URLRequest.init(endpoint: configuration)
        _ = APIClient.sharedObject.load(urlRequest: request, completion: completion)
    }
    
}
