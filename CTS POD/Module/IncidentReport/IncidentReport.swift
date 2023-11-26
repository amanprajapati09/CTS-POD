
import UIKit

final class IncidentReport {
    struct Configuration {
        var usecase: IncidentReportUsecaseProtocol = IncidentReportUsecase(client: IncidentReportClient())
        let images = Images()
        let string = Strings()
        
        init(usecase: IncidentReportUsecaseProtocol) {
            self.usecase = usecase as! IncidentReportUsecase
        }
    }
    
    static func build(reportList: [DynamicReportlist]) -> IncidentNavigatorController {
        let configuration = IncidentReport.Configuration(usecase: IncidentReportUsecase(client: IncidentReportClient()))
        let list = Self.segrigateList(list: reportList)
        let rootViewController = IncidentReportViewController(viewModel: IncidentReportViewModel(configuration: configuration, dynamicReportList: list.first!))
        let viewController = IncidentNavigatorController(viewController: rootViewController, dynamicList: list)
        viewController.modalPresentationStyle = .fullScreen
        return viewController
    }
    
    static private func segrigateList(list: [DynamicReportlist]) -> [[DynamicReportlist]] {
        let updatedList = list.map {
            var updatedValue = $0.copyVariable()
            if $0.isRequierd == true {
                updatedValue.description.append("*")
            }
            return updatedValue
        }
        guard let maxSection = updatedList.map({ $0.sectionNo }).max() else { return [[DynamicReportlist]]() }
        var dynamicList = [[DynamicReportlist]]()
        var index = 1
        while index <= maxSection {            
            dynamicList.append(updatedList.filter({ $0.sectionNo == index}).sorted(by: { $0.order < $1.order }))
            index = index + 1
        }
        return dynamicList
    }
}

extension IncidentReport.Configuration {
    
    struct Images {
        let cameraIcon = UIImage(named: "btn_camera")
    }
    
    struct Strings {
        let buttonPreviousTitle = "Previous"
        let buttonNextTitle = "Next"
        let buttonCameraTitle = "CAPTURE IMAGES"
        let commentMessage = "Please enter required field"
        let cameraNavigationTitle = "Incident Report"
        let imagePickertAlertMessage = "Please capture alt least one image"
        let maxImageAlertMessage = "No more then 20 images are allow to select!"
    }
}
