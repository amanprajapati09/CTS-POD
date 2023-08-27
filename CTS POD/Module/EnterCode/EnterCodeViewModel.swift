
import UIKit

final class EnterCodeViewModel {
    let configuration: EnterCode.Configuration
    let customer: Customer
    
    @Published var viewState: APIState<Otp>?
    
    init(configuration: EnterCode.Configuration, customer: Customer) {
        self.configuration = configuration
        self.customer = customer
    }
    
    func verifyOTP(username: String, client: String) {
        viewState = .loading
        Task {
            do {
                try await configuration.usecase.generateOTP(forgotPasswordRequest: .init(userName: username, customerDomain: client), completion: { result in
                    
                    switch result {
                    case .success(let otpResult):
                        if let otp = otpResult.data?.otp {
                            self.viewState = .loaded(otp)
                        } else {
                            self.viewState = .error(otpResult.message)
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
