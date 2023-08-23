
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
        
        return optionList
    }
    
    private func getSiginOption() -> DashboardDisplayModel {
        if Constant.isLogin {
            return DashboardDisplayModel(title: configuration.string.signOut,
                                                    icon: configuration.images.signin ?? UIImage(),
                                                    type: .login,
                                                    backgroundColor: Colors.colorPrimaryDark,
                                                    textColor: Colors.colorWhite)
        } else {
            return DashboardDisplayModel(title: configuration.string.signin,
                                                    icon: configuration.images.signin ?? UIImage(),
                                                    type: .login,
                                                    backgroundColor: Colors.colorWhite,
                                                    textColor: Colors.colorPrimary)
        }
    }
}

struct DashboardDisplayModel {
    let title: String
    let icon: UIImage
    let type: Dashboard.DashboardOption
    let backgroundColor: UIColor
    let textColor: UIColor
}
