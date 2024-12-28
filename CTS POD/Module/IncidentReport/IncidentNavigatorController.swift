
import UIKit

protocol IncidentNavigatorProtocol: AnyObject {
    func didPressNext(index: Int)
    func didPressPrevious()
    func modifyStatus(item: CheckListItem)
    func updateCheckBox(item: CheckListItem)
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
                if item.type == "Dropdown" {
                    requestModel.values.append(IncedentReportValue(id: item.id, name: item.values.first?.name ?? ""))
                } else {
                    requestModel.values.append(IncedentReportValue(id: item.id, name: ""))
                }
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
        guard viewControllers.count > 1 else {
            dismiss(animated: true)
            return
        }
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
    
    func updateCheckBox(item: CheckListItem) {
        if let index = requestModel.values.firstIndex(where: {$0.id == item.id }) {
            var valueAarray = requestModel.values[index].name.components(separatedBy: ",")
            if let valIndex = valueAarray.firstIndex(where: { $0 == item.value }) {
                valueAarray.remove(at: valIndex)
            } else {
                valueAarray.append(item.value)
            }

            let updatedValue = valueAarray.filter({ !$0.isEmpty }).joined(separator: ",")
            if !updatedValue.isEmpty {
                requestModel.values[index] = IncedentReportValue(id: item.id, name: updatedValue)
            } else {
                requestModel.values[index] = IncedentReportValue(id: item.id, name: "")
            }
            
        } else {
            requestModel.values.append(item.map())
        }
        print(requestModel)
    }
}
