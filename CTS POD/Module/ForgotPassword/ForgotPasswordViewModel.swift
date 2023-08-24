//
//  ForgotPasswordViewModel.swift
//  CTS POD
//
//  Created by jayesh kanzariya on 22/08/23.
//

import UIKit

final class ForgotPasswordViewModel {
    let configuration: ForgotPassword.Configuration
    let customer: Customer
    
    init(configuration: ForgotPassword.Configuration, customer: Customer) {
        self.configuration = configuration
        self.customer = customer
    }
        
}
