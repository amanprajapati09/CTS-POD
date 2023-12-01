
import Foundation

protocol IncidentReportProtocol {
    func fetchDynamicReport(completion: @escaping (Result<IncidentRepostResponseModel, Error>)->()) async throws -> Void
    func postDynamicReport(requestModel:IncidentReportRequestModel, completion: @escaping (Result<IncidentReportResultModel, Error>)->()) async throws -> Void
    func uploadDynamicReportImage(requestModel:IncidentPhotoModel, completion: @escaping (Result<JobStatusUpdateResponse, Error>)->()) async throws -> Void
}

final class IncidentReportClient: IncidentReportProtocol {
    
    enum Endpoint: EndpointConfiguration {
        case fetchList
        case postList(IncidentReportRequestModel)
        case postImage(IncidentPhotoModel)
        
        var path: String {
            switch self {
            case .fetchList:
                return Constant.baseURL + "DynamicIncidentReport/GetIncidenceReportDynamic"
            case .postList:
                return Constant.baseURL + "DynamicIncidentReport/PostReportDetails"
            case .postImage:
                return Constant.baseURL + "Incident/AddPhoto"
            }
        }
        
        var method: RequestMethods {
            switch self {
            case .fetchList:
                return .GET
            case .postList, .postImage:
                return .POST
            }
        }
        
        var body: Encodable? {
            switch self {
            case .fetchList:
                return nil
            case .postList(let request):
                return request
            case .postImage(let request):
                return request
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
    
    func fetchDynamicReport(completion: @escaping (Result<IncidentRepostResponseModel, Error>)->()) async throws {
        let configuration =  IncidentReportClient.Endpoint.fetchList
        var request = try URLRequest.init(endpoint: configuration)
        request.timeoutInterval = 240
        _ = APIClient.sharedObject.load(urlRequest: request, completion: completion)
    }
    
    func postDynamicReport(requestModel: IncidentReportRequestModel, completion: @escaping (Result<IncidentReportResultModel, Error>) -> ()) async throws {
        let configuration = IncidentReportClient.Endpoint.postList(requestModel)
        var request = try URLRequest.init(endpoint: configuration)
        _ = APIClient.sharedObject.load(urlRequest: request, completion: completion)
    }
    
    func uploadDynamicReportImage(requestModel: IncidentPhotoModel, completion: @escaping (Result<JobStatusUpdateResponse, Error>) -> ()) async throws {
        let configuration = IncidentReportClient.Endpoint.postImage(requestModel)
        var request = try URLRequest.init(endpoint: configuration)
        request.timeoutInterval = 240
        _ = APIClient.sharedObject.load(urlRequest: request, completion: completion)
    }
}
