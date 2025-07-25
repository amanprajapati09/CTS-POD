
import UIKit

extension UIStackView {
    
    func removeFully(view: UIView) {
        removeArrangedSubview(view)
        view.removeFromSuperview()
    }
    
    func removeFullyAllArrangedSubviews() {
        arrangedSubviews.forEach { (view) in
            removeFully(view: view)
        }
    }
    
    func replaceView(oldView: UIView, with newView: UIView) {

        guard let index = self.arrangedSubviews.firstIndex(of: oldView) else {
            print("Old view not found in stackView")
            return
        }
        
        self.removeArrangedSubview(oldView)
        oldView.removeFromSuperview()

        self.insertArrangedSubview(newView, at: index)
    }

}
