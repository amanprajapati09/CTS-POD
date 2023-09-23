
import Foundation
protocol VehicleCheckListClientProtocol {
    func getCheckList(completion: @escaping (Result<VehicleCheckListResponse, Error>)->()) async throws -> Void
}

final class VehicleCheckListClientClient: VehicleCheckListClientProtocol {
    
    enum Endpoint: EndpointConfiguration {
        
        case getCheckList
        
        var path: String {
            return Constant.baseURL + "VehicleChecklist/Get"
        }
        
        var method: RequestMethods { return .GET }
        
        var body: Encodable? {
            return nil
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
}
