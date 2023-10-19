
import Foundation
import RealmSwift

class JobConfirmResponse: Decodable {
    let status, message: String
    let data: JobConfirmDataClass
    
    init(status: String, message: String, data: JobConfirmDataClass) {
        self.status = status
        self.message = message
        self.data = data
    }
}

class JobConfirmDataClass: Decodable {
    let jobs: [Job]?
    
    enum CodingKeys: String, CodingKey {
        case jobs = "Jobs"
    }
}

class Job: Object, Decodable {
    @Persisted (primaryKey: true) var id : String
    @Persisted var cmpCode : String?
    @Persisted var createdDate : String?
    @Persisted var deliveryNo : String?
    @Persisted var shipmentStatus : String?
    @Persisted var deliveryDate : String?
    @Persisted var hid : String?
    @Persisted var cmpName : String?
    @Persisted var orderNumber : String?
    @Persisted var yourRef : String?
    @Persisted var sendEmail : String?
    @Persisted var branchCode : String?
    @Persisted var voteCount : String?
    @Persisted var delDebtorName : String?
    @Persisted var delAddressLine1 : String?
    @Persisted var delAddressLine2 : String?
    @Persisted var delAddressLine3 : String?
    @Persisted var delCity : String?
    @Persisted var delStateCode : String?
    @Persisted var delPostCode : String?
    @Persisted var delFullAddress : String?
    @Persisted var delContactperson : String?
    @Persisted var delContactemail : String?
    @Persisted var delPhone : String?
    @Persisted var document : String?
    @Persisted var comments : String?
    @Persisted var notes : String?
    @Persisted var type : String?
    @Persisted var status : Int?
    @Persisted var latitude : Double?
    @Persisted var longitude : Double?
    @Persisted var customOrder : Int?
    @Persisted var isDeleted : Bool?
    @Persisted var branch : String?
    @Persisted var jobStatus : String?
    @Persisted var customerID : String?
    @Persisted var driverSign: Data?
    @Persisted var supervisonSign: Data?
    @Persisted var customerSign: Data?
    @Persisted var customerPhotos: Data?
    @Persisted var deliveryComment: String?
    @Persisted var selectedJob: String?
    @Persisted var ETAStatus: String?
    @Persisted var deliveryStatus: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case cmpCode = "cmp_code"
        case createdDate, deliveryNo, shipmentStatus, deliveryDate, hid
        case cmpName = "cmp_name"
        case orderNumber, yourRef, sendEmail, branchCode, voteCount
        case delDebtorName = "del_debtor_name"
        case delAddressLine1 = "del_AddressLine1"
        case delAddressLine2 = "del_AddressLine2"
        case delAddressLine3 = "del_AddressLine3"
        case delCity = "del_City"
        case delStateCode = "del_StateCode"
        case delPostCode = "del_PostCode"
        case delFullAddress = "del_FullAddress"
        case delContactperson = "del_contactperson"
        case delContactemail = "del_contactemail"
        case delPhone = "del_Phone"
        case document, comments, notes, type, status, latitude, longitude, customOrder, isDeleted, branch, jobStatus, customerID, driverSign, supervisonSign, customerSign, customerPhotos, deliveryComment, selectedJob, ETAStatus, deliveryStatus
    }
    
    func mapToJobConfirmDisplay() -> JobDisplayModel {
        return JobDisplayModel(isExpand: false,
                               job: self)
    }
    
    var titleAddress: String {
        if let delFullAddress {
            return delFullAddress
        } else {
            if let orderNumber {
                return orderNumber + "-" + (delCity ?? "")
            }
        }
        return ""
    }
}
