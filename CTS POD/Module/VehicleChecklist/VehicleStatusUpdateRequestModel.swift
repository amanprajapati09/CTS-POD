
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
}

struct UpdateStatusResult: Codable {
    let status, message: String
}
