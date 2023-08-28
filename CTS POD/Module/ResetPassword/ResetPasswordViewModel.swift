
import UIKit

final class ResetPasswordViewModel {
    let configuration: ResetPassword.Configuration
    let customer: Customer
    let otp: OTP
    
    @Published var viewState: APIState<ResetPasswordResponse>?
    
    init(configuration: ResetPassword.Configuration, customer: Customer, otp: OTP) {
        self.configuration = configuration
        self.customer = customer
        self.otp = otp
    }
        
    func resetPassword(newPassword: String, conformPassword: String) {
        viewState = .loading
        Task {
            do {
                try await configuration.usecase.resetPassword(resetPassword: ResetPasswordRequest(uid: otp.userID, newPassword: newPassword, newConfirmPassword: conformPassword), completion: { result in
                    switch result {
                    case .success(let response):
                        if response.status == "Success" {
                            self.viewState = .loaded(response)
                        } else {
                            self.viewState = .error(response.message)
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
