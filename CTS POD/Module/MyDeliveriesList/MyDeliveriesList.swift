import UIKit

final class MyDeliveriesList {
    struct Configuration {
        let images = Images()
        let string = Strings()
        var usecase: SignInUseCaseProtocol = SignInUseCase(client: SignInClient())
        
        init() { }
    }
    
    static func build() -> MyDeliveriesListViewController {
        let configuration = MyDeliveriesList.Configuration()
        let viewModel = MyDeliveriesListViewModel(configuration: configuration)
        //ResetPasswordViewModel(configuration: configuration, customer: customer, otp: otp)
        let viewController = MyDeliveriesListViewController(viewModel: viewModel)
        return viewController
    }
    
}

extension MyDeliveriesList.Configuration {

    struct Images {
    }

    struct Strings {
        let newPassword = "New Password"
        let confirmPassword = "Confirm password"
        let resetPassword = "Confirm password"
    }
}
