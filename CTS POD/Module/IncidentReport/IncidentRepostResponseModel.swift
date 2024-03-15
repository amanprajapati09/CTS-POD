
import Foundation

struct IncidentRepostResponseModel: Codable {
    let status, message: String
    let signaturedata: String?
    let data: IncidentReportModel
}

// MARK: - DataClass
struct IncidentReportModel: Codable {
    let dynamicReportlist: [DynamicReportlist]
    
    enum CodingKeys: String, CodingKey {
        case dynamicReportlist = "DynamicReportlist"
    }
}

// MARK: - DynamicReportlist
struct DynamicReportlist: Codable {
    let id, createdBy, modifiedBy, createdDate: String
    var modifiedDate, description, type: String
    let values: [Value]
    let status: Status
    let order: Int
    let isRequierd: Bool
    let sectionID: String
    let sectionNo: Int
    let sectionDescription: String
    
    enum CodingKeys: String, CodingKey {
        case id, createdBy, modifiedBy, createdDate, modifiedDate, description, type, values, status, order, isRequierd
        case sectionID = "sectionId"
        case sectionNo, sectionDescription
    }
    
    func copyVariable() -> DynamicReportlist  {
        return self
    }
}

enum Status: String, Codable {
    case active = "active"
}

// MARK: - Welcome
struct IncidentReportRequestModel: Encodable {
    var createdDate: String?
    var photoCount: Int = 0
    var values = [IncedentReportValue]()
}

struct IncidentPhotoModel: Encodable {
    let incidentID: Int
    let photo: String
    let isLandscap: Bool
}

struct IncidentReportResultModel: Decodable {
    let status, message: String
    let data: IncidentReportID
}

struct IncidentReportID: Decodable {
    let IncidentId: Int
}

struct IncedentReportValue: Encodable {
    var id: String
    var name: String
}
