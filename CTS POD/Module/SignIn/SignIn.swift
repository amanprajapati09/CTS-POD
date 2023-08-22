//
//  SignIn.swift
//  CTS POD
//
//  Created by jayesh kanzariya on 21/08/23.
//

import UIKit

final class SignIn {
    struct Configuration {
        let images = Images()
        let string = Strings()
        var usecase: SignInUseCaseProtocol = SignInUseCase(client: SignInClient())

        init(usecase: SignInUseCaseProtocol) {
            self.usecase = usecase
        }
    }
    
    static func build(customer: Customer) -> SignInViewController {
        let configuration = SignIn.Configuration(usecase: SignInUseCase(client: SignInClient()))
        let viewModel = SignInViewModel(configuration: configuration, customer: customer)
        let viewController = SignInViewController(viewModel: viewModel)
        return viewController
    }
    
    public enum DashboardOption: Int {
        case login = 0
        case vehical = 1
        case job = 2
        case deliveries = 3
    }
}

extension SignIn.Configuration {
    
    struct Images {
        
    }
    
    struct Strings {
        let title = "Sign In"
        let subTitle = "Enter your details to sign in your account"
        let signIn = "Sign In"
        let userName = "Username"
        let password = "Password"
        let forgotPassword = "Forgot Password"
    }
}

