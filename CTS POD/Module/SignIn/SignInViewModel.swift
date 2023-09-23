
import UIKit

final class SignInViewModel {
    
    let configuration: SignIn.Configuration
    let customer: Customer
    public var didCompleteLogin: (()->())?
    @Published var viewState: APIState<LoginDetails>?
    
    init(configuration: SignIn.Configuration, customer: Customer) {
        self.configuration = configuration
        self.customer = customer
    }
    
    func signIn(username: String, password: String) {
        viewState = .loading
        Task {
            do {
                try await configuration.usecase.signIn(loginRequest: LoginRequestModel(loginRequest: .init(userName: username, password: password, customerDomain: customer.domainname)), completion: { result in
                    switch result {
                    case .success(let customerResult):
                        if let user = customerResult.data?.loginDetails {
                            LocalTempStorage.storeValue(inUserdefault: user, key: UserDefaultKeys.user)
                            self.viewState = .loaded(user)
                            self.didCompleteLogin?()
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
