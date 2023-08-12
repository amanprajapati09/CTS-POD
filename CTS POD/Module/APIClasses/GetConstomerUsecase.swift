//
//  GetConstomerUsecase.swift
//  CTS POD
//
//  Created by Aman Prajapati on 8/6/23.
//

import Foundation

protocol GetCustomerUsecaseProtocol {
    func getGustomer()
}

final class GetCustomerUsecase: GetCustomerUsecaseProtocol {
    let client: GetCustomerClientProtocol
    init(client: GetCustomerClientProtocol) {
        self.client = client
    }
    func getGustomer() {
        
    }
}
