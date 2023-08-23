//
//  ResetPasswordViewModel.swift
//  CTS POD
//
//  Created by jayesh kanzariya on 23/08/23.
//

import UIKit

final class ResetPasswordViewModel {
    let configuration: ResetPassword.Configuration
    let customer: Customer
    
    init(configuration: ResetPassword.Configuration, customer: Customer) {
        self.configuration = configuration
        self.customer = customer
    }
        
}
