
import UIKit

class LoadingButton: UIButton {
    var originalButtonText: String?
    var originalImage: UIImage?
    var activityIndicator: UIActivityIndicatorView?
    func showLoading() {
        originalButtonText = self.titleLabel?.text
        originalImage = self.imageView?.image
        self.setTitle("", for: .normal)
        if (activityIndicator == nil) {
            activityIndicator = createActivityIndicator()
        }
        showSpinning()
    }
    func hideLoading() {
        self.setTitle(originalButtonText, for: .normal)
        self.imageView?.image = originalImage
        activityIndicator?.stopAnimating()
    }
    private func createActivityIndicator() -> UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = UIColor.lightGray
        return activityIndicator
    }
    private func showSpinning() {
        activityIndicator?.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(activityIndicator!)
        centerActivityIndicatorInButton()
        activityIndicator?.startAnimating()
    }
    private func centerActivityIndicatorInButton() {
        let xCenterConstraint = NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: activityIndicator, attribute: .centerX, multiplier: 1, constant: 0)
        self.addConstraint(xCenterConstraint)
        let yCenterConstraint = NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: activityIndicator, attribute: .centerY, multiplier: 1, constant: 0)
        self.addConstraint(yCenterConstraint)
    }
}
