
import UIKit

class BaseContainerView: UIView {
    
    var models: ValueOption
    var didUpdateValue: ((CheckListItem)->())?
    
    required init(models: ValueOption) {
        self.models = models
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

struct ValueOption {
    let id: String
    let title: String
    var info: [DetailValueOption]
    var prefilledValue: String?
}

struct DetailValueOption {
    let title: String
    let id: Int
    var isCheckd: Bool = false
}

