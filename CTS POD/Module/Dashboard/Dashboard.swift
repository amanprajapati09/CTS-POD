//
//  Dashboard.swift
//  CTS POD
//
//  Created by Aman Prajapati on 8/20/23.
//

import UIKit

final class Dashboard {
    struct Configuration {
        let images = Images()
        let string = Strings()
    }
    
    static func build() -> DashboardViewController {
        let viewController = DashboardViewController(viewModel: .init(configuration: .init()))
        return viewController
    }
    
    public enum DashboardOption: Int {
        case login = 0
        case vehical = 1
        case job = 2
        case deliveries = 3
    }
}

extension Dashboard.Configuration {
    
    struct Images {
        let signin = UIImage(named: "0_dashboard")
        let vehicalCheck = UIImage(named: "1_dashboard")
        let jobConfirm = UIImage(named: "2_dashboard")
        let deleviry = UIImage(named: "3_dashboard")
    }
    
    struct Strings {
        let signin = "Sign In"
        let deleviry = "Deliverie"
        let vehicalCheck = "Vehicle Cheklist"
        let jobConfirm = "Job Confirm"
    }
}
