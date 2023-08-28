
import UIKit
import Foundation

class BaseViewController<VM>: UIViewController {
    var viewModel: VM!
    
    override func viewDidLoad() {
        navigationController?.navigationBar.tintColor = .black        
    }
    deinit {
        debugPrint("Disposed ...\(String(describing: type(of: self)))")
    }
    
    func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { action in
            alert.dismiss(animated: true)
        }))
        navigationController?.present(alert, animated: true)
    }
}
