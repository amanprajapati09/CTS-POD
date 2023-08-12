//
//  GetCustomerClient.swift
//  CTS POD
//
//  Created by Aman Prajapati on 8/6/23.
//

import Foundation
protocol GetCustomerClientProtocol {
    func getCustomer() async throws -> Cat
}

final class GetCustomerClient: GetCustomerClientProtocol {
    
    enum Endpoint: EndpointConfiguration {
       
        case getCustomer(name: String)
        
        var path: String {
            return "https://catfact.ninja/fact"
        }
        
        var method: RequestMethods { return .GET }
        
        var body: Encodable? {
            return nil
        }
        
        var queryParam: [URLQueryItem]? {
            return nil
        }
    }
    
    func getCustomer() async throws -> Cat {
        let configuration = GetCustomerClient.Endpoint.getCustomer(name: "mango")
        return Cat(fact: "", length: 9)
       
    }
}

struct Cat: Decodable {
    let fact: String
    let length: Int
}
