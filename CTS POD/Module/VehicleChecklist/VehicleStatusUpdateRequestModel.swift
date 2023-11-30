
import Foundation

struct VehicleStatusUpdateRequestModel: Encodable {
    var createdDate: String?
    var vehicleStatus: String?
    var comments: String?
    var checklists = [CheckListItem]()
}

struct CheckListItem: Encodable {
    var id: String
    var value: String
    
    func map() -> IncedentReportValue {
        return IncedentReportValue(id: id, name: value)
    }
}

struct UpdateStatusResult: Codable {
    let status, message: String
}
