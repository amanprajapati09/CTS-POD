
import UIKit

protocol IncidentNavigatorProtocol: AnyObject {
    func didPressNext(index: Int)
    func didPressPrevious()
    func modifyStatus(item: CheckListItem)
}

class IncidentNavigatorController: UINavigationController {
    
    let dynamicList: [[DynamicReportlist]]
    var requestModel = IncidentReportRequestModel(createdDate: "")
    
    init (viewController: IncidentReportViewController, dynamicList: [[DynamicReportlist]]) {
        self.dynamicList = dynamicList
        super.init(rootViewController: viewController)
        viewController.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for section in dynamicList {
            for item in section {
                requestModel.values.append(IncedentReportValue(id: item.id, name: ""))
            }
        }
    }
}

extension IncidentNavigatorController: IncidentNavigatorProtocol {
    func didPressNext(index: Int) {
        let configuration = IncidentReport.Configuration(usecase: IncidentReportUsecase(client: IncidentReportClient()))
        
        if index == dynamicList.count {
            let viewController = IncidentReportCameraViewController(viewModel: .init(configuration: configuration))
            viewController.delegate = self
            pushViewController(viewController, animated: true)
        } else {
            let viewController = IncidentReportViewController(viewModel: IncidentReportViewModel(configuration: configuration, dynamicReportList: dynamicList[index]))
            viewController.delegate = self
            pushViewController(viewController, animated: true)
        }
    }
    
    func didPressPrevious() {
        popViewController(animated: true)
    }
    
    func modifyStatus(item: CheckListItem) {
        if let index = requestModel.values.firstIndex(where: {$0.id == item.id }) {
            requestModel.values[index] = item.map()
        } else {
            requestModel.values.append(item.map())
        }
        print(requestModel)
    }
}
