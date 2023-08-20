//
//  GetCustomerModels.swift
//  CTS POD
//
//  Created by Aman Prajapati on 8/19/23.
//

import UIKit

struct Customer: Codable {
    let logo: String
    let workflow: [Workflow]
    let status: Int
    let domainname, forgotpassword: String
}

struct Workflow: Codable {
    let flowID: Int
    let flowName: String
    
    func mapToDisplay() -> DashboardDisplayModel {
        return DashboardDisplayModel(title: flowName,
                                     icon: UIImage(named: "\(flowID)_dashboard") ?? UIImage() ,
                                     type: Dashboard.DashboardOption(rawValue: flowID) ?? .login,
                                     backgroundColor: Colors.colorPrimaryDark)
    }
}

struct DataClass: Decodable {
    let Customer: Customer?
}

struct CustomerResult: Decodable {
    let status: String
    let message: String
    let data: DataClass?
}
