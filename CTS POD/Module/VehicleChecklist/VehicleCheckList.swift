
import Foundation

final class VehicleCheckList {
    struct Configuration {
        var usecase: VehicleCheckListUsecase = VehicleCheckListUsecase(client: VehicleCheckListClientClient())
        let images = Images()
        let string = Strings()
        
        init(usecase: VehicleCheckListUsecaseProtocol) {
            self.usecase = usecase as! VehicleCheckListUsecase
        }
    }
    
    static func build() -> VehicleCheckListViewController {
        let configuration = VehicleCheckList.Configuration(usecase: VehicleCheckListUsecase(client: VehicleCheckListClientClient()))
        let viewController = VehicleCheckListViewController(viewModel: .init(configuration: configuration))
        return viewController
    }
}

extension VehicleCheckList.Configuration {
    
    struct Images {}
    
    struct Strings {
        let navigationTitle = "Vehicle Checklist"
        let buttonSafeTitle = "Vehicle safe"
        let buttonUnSafeTitle = "Vehicle unsafe"
        let commentMessage = "Please enter a comment"
    }
}

