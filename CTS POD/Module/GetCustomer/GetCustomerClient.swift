//
//  GetCustomerClient.swift
//  CTS POD
//
//  Created by Aman Prajapati on 8/6/23.
//

import Foundation
protocol GetCustomerClientProtocol {
    func getCustomer(name: String, completion: @escaping (Result<CustomerResult, Error>)->()) async throws -> Void
}

final class GetCustomerClient: GetCustomerClientProtocol {
    
    enum Endpoint: EndpointConfiguration {
       
        case getCustomer(name: String)
        
        var path: String {
            return Constant.baseURL + "User/GetCustomer"
        }
        
        var method: RequestMethods { return .GET }
        
        var body: Encodable? {
            return nil
        }
        
        var queryParam: [URLQueryItem]? {
            switch self {
            case .getCustomer(let name):
                return [URLQueryItem(name: "domain", value: name)]
            }
        }
    }
    
    func getCustomer(name: String, completion: @escaping (Result<CustomerResult, Error>)->()) async throws -> Void {
        let configuration = GetCustomerClient.Endpoint.getCustomer(name: name)
        let request = try URLRequest.init(endpoint: configuration)
        _ = APIClient.sharedObject.load(urlRequest: request, completion: completion)
    }
}
