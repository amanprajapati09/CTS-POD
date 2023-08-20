//
//  GetCustomerViewModel.swift
//  CTS POD
//
//  Created by Aman Prajapati on 8/17/23.
//

import Foundation
import Combine

class GetCustomerViewModel {
    let configuration: GetCustomer.Configuration
    
    init(configuration: GetCustomer.Configuration) {
        self.configuration = configuration
    }
    
    func fetchCustomer(name: String)  {
        Task {
            do {
                try await configuration.usecase.getGustomer(name: name)
            } catch {
                print("error")
            }
        }
    }
}
