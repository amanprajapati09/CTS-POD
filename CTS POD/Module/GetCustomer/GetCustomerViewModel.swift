
import Foundation
import Combine

enum APIState<T: Decodable> {
    case loading
    case loaded(T)
    case error(String)
}

class GetCustomerViewModel {
    let configuration: GetCustomer.Configuration
    
    @Published var viewState: APIState<Customer>?    
    
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
                            LocalTempStorage.storeValue(inUserdefault: customer, key: "customer")
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
