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
    
    static func build() -> GetCustomerViewController {
        let viewController = d
        return viewController
    }
}

extension Dashboard.Configuration {
    
    struct Images {
        let logo = UIImage(named: "logoImage")
    }
    
    struct Strings {
        let title = "Organization"
        let info = "Please enter your organization name"
        let buttonTitle = "Go"
    }
}


//let newImageData = Data(base64Encoded: imageBase64String!)
//
//if let newImageData = newImageData {
//   myImageView.image = UIImage(data: newImageData)
//}
