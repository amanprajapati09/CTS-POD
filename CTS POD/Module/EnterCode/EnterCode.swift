//
//  EnterCode.swift
//  CTS POD
//
//  Created by jayesh kanzariya on 23/08/23.
//

import UIKit

final class EnterCode {
    struct Configuration {
        let images = Images()
        let string = Strings()
        var usecase: SignInUseCaseProtocol = SignInUseCase(client: SignInClient())

        init(usecase: SignInUseCaseProtocol) {
            self.usecase = usecase
        }
    }
    
    static func build(customer: Customer) -> EnterCodeViewController {
        let configuration = EnterCode.Configuration(usecase: SignInUseCase(client: SignInClient()))
        let viewModel = EnterCodeViewModel(configuration: configuration, customer: customer)
        let viewController = EnterCodeViewController(viewModel: viewModel)
        return viewController
    }
}

extension EnterCode.Configuration {
    
    struct Images {
    }
    
    struct Strings {
        let didNotReceiveCode = "Don't Receive Code?"
        let verifyCode = "Verify Code"
    }
}



