
import Foundation

final class DeliverySubmit {
    struct Configuration {
        let images = Images()
        let string = Strings()
        var usecase: SignInUseCaseProtocol = SignInUseCase(client: SignInClient())
        
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
    }

    struct Strings {
        let navigationTitle = "Sales Order"        
    }
}
