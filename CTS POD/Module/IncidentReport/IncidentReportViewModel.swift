
import Foundation

final class IncidentReportViewModel {
    let configuration: IncidentReport.Configuration
    let dynamicReportList: [DynamicReportlist]
    
    init(configuration: IncidentReport.Configuration, dynamicReportList: [DynamicReportlist]) {
        self.configuration = configuration
        self.dynamicReportList = dynamicReportList
    }
}
