
import UIKit

final class ForgotPasswordViewModel {
    let configuration: ForgotPassword.Configuration
    let customer: Customer
    @Published var viewState: APIState<OTP>?
    
    init(configuration: ForgotPassword.Configuration, customer: Customer) {
        self.configuration = configuration
        self.customer = customer
    }
        
    func generateOTP(username: String, client: String) {
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
                            ErrorLogManager.uploadErrorLog(apiName: "User/GenerateOTPAPI", error: otpResult.message)
                        }
                    case .failure(let error):
                        self.viewState = .error("Somthing went wrong!")
                        ErrorLogManager.uploadErrorLog(apiName: "User/GenerateOTPAPI", error: error.localizedDescription)
                    }
                })
            } catch {
                viewState = .error("Somthing went wrong!")
            }
        }
    }
}
