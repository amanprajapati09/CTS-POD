
import UIKit

final class DeliverySubmit {
    struct Configuration {
        let images = Images()
        let string = Strings()
        var usecase: SignInUseCaseProtocol = SignInUseCase(client: SignInClient())
        let optionList: [DeliveryOption] = [.deliver, .deliveredNoSign, .unableToDeliver]
        init() { }
    }
    
    static func build(jobs: [Job]) -> DeliverySubmitViewController {
        let configuration = DeliverySubmit.Configuration()
        let viewModel = DeliverySubmitViewModel(jobs: jobs, configuration: configuration)
        let viewController = DeliverySubmitViewController(viewModel: viewModel)
        return viewController
    }
}

extension DeliverySubmit.Configuration {
    
    struct Images {
        let cameraIcon = UIImage(named: "btn_camera")
        let signatureIcon = UIImage(named: "btn_signature")
    }
    
    struct Strings {
        let navigationTitle = "Sales Order"
        let signatureTitle = "Signature"
        let cameraTitle = "Camera"
    }
}

enum DeliveryOption: String {
    case deliver = "Deliver"
    case deliveredNoSign = "Delivered/No Sign"
    case unableToDeliver = "Unable to Deliver"
    
    var status: Int {
        switch self {
        case .deliver: return 6
        case .deliveredNoSign: return 7
        case .unableToDeliver: return 8
        }
    }
}
