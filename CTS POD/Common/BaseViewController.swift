//
//  BaseViewController.swift
//  CTS POD
//
//  Created by jayesh kanzariya on 21/08/23.
//

import UIKit
import Foundation

class BaseViewController<VM>: UIViewController {
    var viewModel: VM!
    
    deinit {
        debugPrint("Disposed ...\(String(describing: type(of: self)))")
    }
}
