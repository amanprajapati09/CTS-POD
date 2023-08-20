//
//  GetCustomerModels.swift
//  CTS POD
//
//  Created by Aman Prajapati on 8/19/23.
//

import Foundation

struct Customer: Decodable {
    let logo: String
    let workflow: [Workflow]
    let status: Int
    let domainname, forgotpassword: String
}

struct Workflow: Decodable {
    let flowID: Int
    let flowName: String
}

struct DataClass: Decodable {
    let Customer: Customer
}

struct CustomerResult: Decodable {
    let status: String
    let message: String
    let data: DataClass
}
