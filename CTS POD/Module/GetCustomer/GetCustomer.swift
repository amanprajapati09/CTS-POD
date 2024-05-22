
import UIKit

final class GetCustomer {
    struct Configuration {
        var usecase: GetCustomerUsecaseProtocol = GetCustomerUsecase(client: GetCustomerClient())
        let images = Images()
        let string = Strings()
        
        init(usecase: GetCustomerUsecaseProtocol) {
            self.usecase = usecase
        }
    }
    
    static func build() -> GetCustomerViewController {
        let configuration = GetCustomer.Configuration(usecase: GetCustomerUsecase(client: GetCustomerClient()))
        let viewController = GetCustomerViewController(viewModel: .init(configuration: configuration))
        return viewController
    }
}

extension GetCustomer.Configuration {
    
    struct Images {
        let logo = UIImage(named: "logoImage")
    }
    
    struct Strings {
        let title = "Organisation"
        let info = "Please enter your organisation name"
        let buttonTitle = "Go"
    }
}
