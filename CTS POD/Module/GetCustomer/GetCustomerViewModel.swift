//
//  GetCustomerViewModel.swift
//  CTS POD
//
//  Created by Aman Prajapati on 8/17/23.
//

import Foundation
import Combine

enum APIState {
    case loading
    case loaded
    case error(String)
}

class GetCustomerViewModel {
    let configuration: GetCustomer.Configuration
    
    @Published var viewState: APIState?    
    
    init(configuration: GetCustomer.Configuration) {
        self.configuration = configuration
    }
    
    func fetchCustomer(name: String)  {
        viewState = .loading
        Task {
            do {
                try await configuration.usecase.getGustomer(name: name, completion: { result in
                    self.viewState = .loaded
                    switch result {
                    case .success(let customerResult):
                        SharedObject.shared.customer = customerResult.data.Customer
                    case .failure:
                        self.viewState = .error("")
                    }
                })
            } catch {
                print("error")
                viewState = .error("Locha")
            }
        }
    }
}
