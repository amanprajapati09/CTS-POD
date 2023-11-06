
import UIKit

extension UINavigationController {
    
    func findViewController<T: UIViewController>(type: T.Type) -> T? {
        for controller in viewControllers  {
            if controller.isKind(of: T.self) {
                return controller as? T
            }
        }
        return nil
    }
}
