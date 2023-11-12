
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
    let sectionDescription: SectionDescription
    
    enum CodingKeys: String, CodingKey {
        case id, createdBy, modifiedBy, createdDate, modifiedDate, description, type, values, status, order, isRequierd
        case sectionID = "sectionId"
        case sectionNo, sectionDescription
    }
    
    func copyVariable() -> DynamicReportlist  {
        return self
    }
}

enum SectionDescription: String, Codable {
    case cookSDriverQuestionnaire = "Cook's Driver Questionnaire"
    case cookSEmployeeDetails = "Cook's Employee Details"
    case outsidePartyInformationOtherDriverInvolvedInIncident = "Outside Party Information (other Driver involved in incident) "
    case safetyReport = "Safety Report"
}

enum Status: String, Codable {
    case active = "active"
}

// MARK: - Welcome
struct IncidentReportRequestModel: Encodable {
    var createdDate: String?
    var photoCount: Int = 0
    var values = [CheckListItem]()
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
