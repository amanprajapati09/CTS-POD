
import UIKit

final class ForgotPassword {
    struct Configuration {
        let images = Images()
        let string = Strings()
        var usecase: SignInUseCaseProtocol = SignInUseCase(client: SignInClient())

        init(usecase: SignInUseCaseProtocol) {
            self.usecase = usecase
        }
    }
    
    static func build(customer: Customer) -> ForgotPasswordViewController {
        let configuration = ForgotPassword.Configuration(usecase: SignInUseCase(client: SignInClient()))
        let viewModel = ForgotPasswordViewModel(configuration: configuration, customer: customer)
        let viewController = ForgotPasswordViewController(viewModel: viewModel)
        return viewController
    }
}

extension ForgotPassword.Configuration {
    
    struct Images {
        let icnRadioOn = UIImage(named: "icn_radio_on")
        let icnRadioOff = UIImage(named: "icn_radio_off")
    }
    
    struct Strings {
        let generateCode = "Generate Code"
        let note = "Note: Contact admistrator for instant password change."
        let userName = "Username"
    }
}


