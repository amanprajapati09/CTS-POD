//
//  ResetPasswordRequest.swift
//  CTS POD
//
//  Created by Aman Prajapati on 8/28/23.
//

import Foundation

struct ResetPasswordRequest: Encodable {
    let uid: String
    let newPassword: String
    let newConfirmPassword: String
}
    
struct ResetPasswordResponse: Codable {
    let status, message: String
}
