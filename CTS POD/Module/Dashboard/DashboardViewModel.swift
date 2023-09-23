
import UIKit

final class DashboardViewModel {
    let configuration: Dashboard.Configuration
    let customer: Customer
    
    init(configuration: Dashboard.Configuration, customer: Customer) {
        self.configuration = configuration
        self.customer = customer
    }
    
    func fetchOptions() -> [DashboardDisplayModel]  {
        var optionList = [DashboardDisplayModel]()
        optionList.append(getSiginOption())
        let options = (customer.workflow.map { $0.mapToDisplay() })
        optionList += options
        
        return updateVehicleCheckListOption(optionList: optionList).sorted(by: { $0.id < $1.id })
    }
    
    private func getSiginOption() -> DashboardDisplayModel {
        if Constant.isLogin {
            return DashboardDisplayModel(id: 0,
                                         title: configuration.string.signOut,
                                         icon: configuration.images.signin ?? UIImage(),
                                         type: .login,
                                         backgroundColor: Colors.colorPrimaryDark,
                                         textColor: Colors.colorWhite)
        } else {
            return DashboardDisplayModel(id: 0,
                                         title: configuration.string.signin,
                                         icon: configuration.images.signin ?? UIImage(),
                                         type: .login,
                                         backgroundColor: Colors.colorWhite,
                                         textColor: Colors.colorPrimary)
        }
    }
    
    private func updateVehicleCheckListOption(optionList: [DashboardDisplayModel]) -> [DashboardDisplayModel] {
        return optionList.map { model in
            if Constant.isVehicalCheck, model.id == 1 {
                return DashboardDisplayModel(id: model.id,
                                             title: model.title,
                                             icon: model.icon,
                                             type: model.type,
                                             backgroundColor: Colors.colorWhite,
                                             textColor: Colors.colorPrimary)
            }
               
            return model
        }
    }
}

struct DashboardDisplayModel {
    let id: Int
    let title: String
    let icon: UIImage
    let type: Dashboard.DashboardOption
    let backgroundColor: UIColor
    let textColor: UIColor
}
