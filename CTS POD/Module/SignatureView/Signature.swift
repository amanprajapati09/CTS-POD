
import Foundation

final class Signature {
    struct Configuration {
        let images = Images()
        let string = Strings()
        var usecase: SignInUseCaseProtocol = SignInUseCase(client: SignInClient())
        
        init() { }
    }
    
    static func build(signType: SignatureType) -> SignViewController {
        let configuration = Signature.Configuration()
        let viewModel = SignViewModel(configuration: configuration, signType: signType)
        let viewController = SignViewController(viewModel: viewModel)
        viewController.modalPresentationStyle = .fullScreen
        return viewController
    }
    
}

extension Signature.Configuration {

    struct Images {
    }

    struct Strings {
        let cancelTitle = "Cancel"
        let clearTitle = "Clear"
        let saveTitle = "Save"
    }
}
