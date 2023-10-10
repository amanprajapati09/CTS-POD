
import Foundation

extension String {
    func toMyModuleClass() -> AnyClass? {
        struct My {
            static let moduleName = String(reflecting: BaseContainerView.self).prefix{$0 != "."}
        }
        return NSClassFromString("\(My.moduleName).\(self)")
    }
}
