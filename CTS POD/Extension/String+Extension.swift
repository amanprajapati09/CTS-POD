
import Foundation
import UIKit

extension String {
    func toMyModuleClass() -> AnyClass? {
        struct My {
            static let moduleName = String(reflecting: BaseContainerView.self).prefix{$0 != "."}
        }
        return NSClassFromString("\(My.moduleName).\(self)")
    }
    public var attributedString: NSMutableAttributedString {
        let attString = NSMutableAttributedString(string: self)
        let asteriskRange = (description as NSString).range(of: "*")
        attString.addAttribute(.foregroundColor, value: UIColor.red, range: asteriskRange)
        return attString
    }
}
