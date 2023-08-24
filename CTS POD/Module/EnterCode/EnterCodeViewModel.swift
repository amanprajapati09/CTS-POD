//
//  EnterCodeViewModel.swift
//  CTS POD
//
//  Created by jayesh kanzariya on 23/08/23.
//

import UIKit

final class EnterCodeViewModel {
    let configuration: EnterCode.Configuration
    let customer: Customer
    
    init(configuration: EnterCode.Configuration, customer: Customer) {
        self.configuration = configuration
        self.customer = customer
    }
        
}
