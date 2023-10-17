
import UIKit

final class DeliveriesConfirm {
    struct Configuration {
        let images = Images()
        let string = Strings()
        var usecase: SignInUseCaseProtocol = SignInUseCase(client: SignInClient())
        
        init() { }
    }
    
    static func build() -> DeliveriesConfirmViewController {
        let configuration = DeliveriesConfirm.Configuration()
        let viewModel = DeliveriesConfirmViewModel(configuration: configuration)
        //ResetPasswordViewModel(configuration: configuration, customer: customer, otp: otp)
        let viewController = DeliveriesConfirmViewController(viewModel: viewModel)
        return viewController
    }
    
}

extension DeliveriesConfirm.Configuration {

    struct Images {
    }

    struct Strings {
        let newPassword = "New Password"
        let confirmPassword = "Confirm password"
        let resetPassword = "Confirm password"
    }
}
