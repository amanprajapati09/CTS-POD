//
//  GetConstomerUsecase.swift
//  CTS POD
//
//  Created by Aman Prajapati on 8/6/23.
//

import Foundation

protocol GetCustomerUsecaseProtocol {
    func getGustomer(name: String, completion: @escaping (Result<CustomerResult, Error>)->()) async throws -> Void
}

final class GetCustomerUsecase: GetCustomerUsecaseProtocol {
    let client: GetCustomerClientProtocol
    init(client: GetCustomerClientProtocol) {
        self.client = client
    }
    
    func getGustomer(name: String, completion: @escaping (Result<CustomerResult, Error>)->()) async throws -> Void {
        return try await client.getCustomer(name: name, completion: completion)
    }
}
