
import UIKit

final class EnterCodeViewModel {
    let configuration: EnterCode.Configuration
    let customer: Customer
    let user: String?
    
    @Published var viewState: APIState<OTP>?
    
    init(configuration: EnterCode.Configuration, customer: Customer, user: String?) {
        self.configuration = configuration
        self.customer = customer
        self.user = user
    }
    
    func verifyOTP(otpValue: String) {
        viewState = .loading
        Task {
            do {
                try await configuration.usecase.validateOTP(validateOTPRequest: ValidateOTPRequest(userName: user ?? "", customerDomain: customer.domainname, generatedOTP: otpValue), completion: { result in
                    switch result {
                    case .success(let otpResult):
                        if let otp = otpResult.data?.otp {
                            self.viewState = .loaded(otp)
                        } else {
                            self.viewState = .error(otpResult.message)
                            ErrorLogManager.uploadErrorLog(apiName: "User/ValidateOTPAPI", error: otpResult.message)
                        }
                    case .failure(let error):
                        ErrorLogManager.uploadErrorLog(apiName: "User/ValidateOTPAPI", error: error.localizedDescription)
                    }
                })
            } catch {
                viewState = .error("Somthing went wrong!")
            }
        }
    }
        
}
