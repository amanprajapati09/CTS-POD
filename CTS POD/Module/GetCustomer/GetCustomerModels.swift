
import UIKit

struct Customer: Codable {
    let logo: String
    let workflow: [Workflow]
    let status: Int
    let domainname, forgotpassword: String
    
    var hasVehicalCheckList: Bool {
        return workflow.filter{
            $0.flowID == 1
        }.isEmpty
    }
}

struct Workflow: Codable {
    let flowID: Int
    let flowName: String
    
    func mapToDisplay() -> DashboardDisplayModel {
        return DashboardDisplayModel(id: flowID,
                                     title: flowName,
                                     icon: UIImage(named: "\(flowID)_dashboard") ?? UIImage() ,
                                     type: Dashboard.DashboardOption(rawValue: flowID) ?? .login,
                                     backgroundColor: Colors.colorPrimaryDark,
                                     textColor: Colors.colorPrimary)
    }
}

struct DataClass: Decodable {
    let Customer: Customer?
}

struct CustomerResult: Decodable {
    let status: String
    let message: String
    let data: DataClass?
}
