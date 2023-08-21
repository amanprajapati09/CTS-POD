//
//  SignInViewModel.swift
//  CTS POD
//
//  Created by jayesh kanzariya on 21/08/23.
//

import UIKit

final class SignInViewModel {
    
    let configuration: SignIn.Configuration
    let customer: Customer
    @Published var viewState: APIState?
    
    init(configuration: SignIn.Configuration, customer: Customer) {
        self.configuration = configuration
        self.customer = customer
    }
    
    func signIn(username: String, password: String) {
        viewState = .loading
        Task {
            do {
                try await configuration.usecase.signIn(username: username, password: password, completion: { result in
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
