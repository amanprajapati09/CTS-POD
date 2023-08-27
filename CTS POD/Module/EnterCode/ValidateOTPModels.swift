//
//  ValidateOTPModels.swift
//  CTS POD
//
//  Created by Aman Prajapati on 8/25/23.
//

import Foundation

struct ValidateOTPRequest: Encodable {
    let userName: String
    let customerDomain: String
    let generatedOTP: String
}
