//
//  GetCustomer.swift
//  CTS POD
//
//  Created by Aman Prajapati on 8/19/23.
//

import UIKit

final class GetCustomer {
    struct Configuration {
        var usecase: GetCustomerUsecaseProtocol = GetCustomerUsecase(client: GetCustomerClient())
        let images = Images()
        let string = Strings()
        
        init(usecase: GetCustomerUsecaseProtocol) {
            self.usecase = usecase
        }
    }
    
    static func build() -> GetCustomerViewController {
        let configuration = GetCustomer.Configuration(usecase: GetCustomerUsecase(client: GetCustomerClient()))
        let viewController = GetCustomerViewController(viewModel: .init(configuration: configuration))
        return viewController
    }
}

extension GetCustomer.Configuration {
    
    struct Images {
        let logo = UIImage(named: "logoImage")
    }
    
    struct Strings {
        let title = "Organization"
        let info = "Please enter your organization name"
        let buttonTitle = "Go"
    }
}
