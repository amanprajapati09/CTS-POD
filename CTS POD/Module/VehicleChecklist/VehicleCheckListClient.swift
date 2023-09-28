
import Foundation
protocol VehicleCheckListClientProtocol {
    func getCheckList(completion: @escaping (Result<VehicleCheckListResponse, Error>)->()) async throws -> Void
    func updateVehicleStatus(request:VehicleStatusUpdateRequestModel, completion: @escaping (Result<UpdateStatusResult, Error>)->()) async throws -> Void
}

final class VehicleCheckListClientClient: VehicleCheckListClientProtocol {
    
    enum Endpoint: EndpointConfiguration {
        
        case getCheckList
        case updateStatus(VehicleStatusUpdateRequestModel)
        
        var path: String {
            switch self {
            case .getCheckList: return Constant.baseURL + "VehicleChecklist/Get"
            case .updateStatus: return Constant.baseURL + "VehicleChecklist/Post"
            }
        }
        
        var method: RequestMethods {
            switch self {
            case .getCheckList: return .GET
            case .updateStatus: return .POST
            }
        }
        
        var body: Encodable? {
            switch self {
            case .getCheckList: return nil
            case .updateStatus(let request): return request
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
    
    func getCheckList(completion: @escaping (Result<VehicleCheckListResponse, Error>)->()) async throws -> Void {
        let configuration = VehicleCheckListClientClient.Endpoint.getCheckList
        let request = try URLRequest.init(endpoint: configuration)
        _ = APIClient.sharedObject.load(urlRequest: request, completion: completion)
    }
    
    func updateVehicleStatus(request: VehicleStatusUpdateRequestModel, completion: @escaping (Result<UpdateStatusResult, Error>) -> ()) async throws {
        let configuration =  VehicleCheckListClientClient.Endpoint.updateStatus(request)
        let request = try URLRequest.init(endpoint: configuration)
        _ = APIClient.sharedObject.load(urlRequest: request, completion: completion)
    }
}
