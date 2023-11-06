
import UIKit

extension UIImage {
    var base64String: String? {
        let imageData = self.pngData()
        return imageData?.base64EncodedString(options: .lineLength64Characters)
    }
}
