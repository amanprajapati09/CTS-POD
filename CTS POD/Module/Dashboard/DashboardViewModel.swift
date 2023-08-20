//
//  DashboardViewModel.swift
//  CTS POD
//
//  Created by Aman Prajapati on 8/20/23.
//

import UIKit

final class DashboardViewModel {
    let configuration: Dashboard.Configuration
    let customer: Customer?
    
    init(configuration: Dashboard.Configuration) {
        self.configuration = configuration
        customer = LocalTempStorage.getValue(fromUserDefault: Customer.self, key: "customer")
    }
    
    func fetchOptions() -> [DashboardDisplayModel]  {
        var optionList = [DashboardDisplayModel]()
        optionList.append(DashboardDisplayModel(title: configuration.string.signin,
                                                icon: configuration.images.signin ?? UIImage(),
                                                type: .login,
                                                backgroundColor: Colors.colorWhite))
        if let options = (customer?.workflow.map { $0.mapToDisplay() }) {
            optionList += options
        }
        
        return optionList
    }
    
}

struct DashboardDisplayModel {
    let title: String
    let icon: UIImage
    let type: Dashboard.DashboardOption
    let backgroundColor: UIColor
}
