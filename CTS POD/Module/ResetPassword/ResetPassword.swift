
import UIKit

final class ResetPassword {
    struct Configuration {
        let images = Images()
        let string = Strings()
        var usecase: SignInUseCaseProtocol = SignInUseCase(client: SignInClient())

        init(usecase: SignInUseCaseProtocol) {
            self.usecase = usecase
        }
    }
    
    static func build(customer: Customer, otp: OTP) -> ResetPasswordViewController {
        let configuration = ResetPassword.Configuration(usecase: SignInUseCase(client: SignInClient()))
        let viewModel = ResetPasswordViewModel(configuration: configuration, customer: customer, otp: otp)
        let viewController = ResetPasswordViewController(viewModel: viewModel)
        return viewController
    }
}

extension ResetPassword.Configuration {
    
    struct Images {
    }
    
    struct Strings {
        let newPassword = "New Password"
        let confirmPassword = "Confirm password"
        let resetPassword = "Confirm password"
    }
}
