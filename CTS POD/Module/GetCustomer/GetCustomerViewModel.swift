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
    case loaded(Customer)
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
                    switch result {
                    case .success(let customerResult):
                        if let customer = customerResult.data?.Customer {
                            SharedObject.shared.customer = customer
                            LocalTempStorage.storeValuse(inUserdefault: customer, key: "customer")
                            self.viewState = .loaded(customer)
                        } else {
                            self.viewState = .error(customerResult.message)
                        }
                    case .failure:
                        self.viewState = .error("Somthing went wrong!")
                    }
                })
            } catch {               
                viewState = .error("Somthing went wrong!")
            }
        }
    }
}
