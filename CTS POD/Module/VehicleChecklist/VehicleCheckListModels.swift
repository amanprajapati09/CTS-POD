
import Foundation

struct VehicleCheckListResponse: Codable {
    let status, message: String
    let data: VehicleCheckListDataClass
}

struct VehicleCheckListDataClass: Codable {
    let vehicleChecklist: [VehicleChecklist]

    enum CodingKeys: String, CodingKey {
        case vehicleChecklist = "VehicleChecklist"
    }
}

struct VehicleChecklist: Codable {
    let id, createdBy, modifiedBy, createdDate: String
    let modifiedDate: String
    let deleted: Bool
    let description, type: String
    let values: [Value]
    let status: String
}

struct Value: Codable {
    let id: Int
    let name: String
    
    func map() -> CheckBoxInfo {
        return CheckBoxInfo(title: name, id: id)
    }
}

enum VehicalCheckType: String {
    case Checkbox
    case Text
    case Dropdown
    case Number
}
