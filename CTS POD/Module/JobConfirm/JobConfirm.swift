
import UIKit

final class JobConfirm {
    struct Configuration {
        let images = Images()
        let string = Strings()
        var usecase: SignInUseCaseProtocol = SignInUseCase(client: SignInClient())
        
        init() { }
    }
    
    static func build() -> JobConfirmListViewController {
        let configuration = JobConfirm.Configuration()
        let viewModel = JobConfirmListViewModel(configuration: configuration)
        //ResetPasswordViewModel(configuration: configuration, customer: customer, otp: otp)
        let viewController = JobConfirmListViewController(viewModel: viewModel)
        return viewController
    }
    
}

extension JobConfirm.Configuration {

    struct Images {
    }

    struct Strings {
        let newPassword = "New Password"
        let confirmPassword = "Confirm password"
        let resetPassword = "Confirm password"
        
        let driverSignTitle = "Driver Sign"
        let superVisionTitle = "Supervisor sign"
        let allTitle = "All"
        
        let navigationTitle = "Deliveries Confirm"
    }
}
