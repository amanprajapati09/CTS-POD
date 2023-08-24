
import UIKit
import Foundation

class BaseViewController<VM>: UIViewController {
    var viewModel: VM!
    
    deinit {
        debugPrint("Disposed ...\(String(describing: type(of: self)))")
    }
}
