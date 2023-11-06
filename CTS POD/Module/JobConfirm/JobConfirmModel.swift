
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
    
    var locationAddress: String {
        if let delAddressLine1 {
            return delAddressLine1
        } else if let delAddressLine2 {
            return delAddressLine2
        } else if let delAddressLine3 {
            return delAddressLine3
        }
        return ""
    }
    
    init(id: String, cmpCode: String? = nil, createdDate: String? = nil, deliveryNo: String? = nil, shipmentStatus: String? = nil, deliveryDate: String? = nil, hid: String? = nil, cmpName: String? = nil, orderNumber: String? = nil, yourRef: String? = nil, sendEmail: String? = nil, branchCode: String? = nil, voteCount: String? = nil, delDebtorName: String? = nil, delAddressLine1: String? = nil, delAddressLine2: String? = nil, delAddressLine3: String? = nil, delCity: String? = nil, delStateCode: String? = nil, delPostCode: String? = nil, delFullAddress: String? = nil, delContactperson: String? = nil, delContactemail: String? = nil, delPhone: String? = nil, document: String? = nil, comments: String? = nil, notes: String? = nil, type: String? = nil, status: Int? = nil, latitude: Double? = nil, longitude: Double? = nil, customOrder: Int? = nil, isDeleted: Bool? = nil, branch: String? = nil, jobStatus: String? = nil, customerID: String? = nil, driverSign: Data? = nil, supervisonSign: Data? = nil, customerSign: Data? = nil, customerPhotos: Data? = nil, deliveryComment: String? = nil, selectedJob: String? = nil, ETAStatus: String? = nil, deliveryStatus: String? = nil) {
        super.init()
        self.id = id
        self.cmpCode = cmpCode
        self.createdDate = createdDate
        self.deliveryNo = deliveryNo
        self.shipmentStatus = shipmentStatus
        self.deliveryDate = deliveryDate
        self.hid = hid
        self.cmpName = cmpName
        self.orderNumber = orderNumber
        self.yourRef = yourRef
        self.sendEmail = sendEmail
        self.branchCode = branchCode
        self.voteCount = voteCount
        self.delDebtorName = delDebtorName
        self.delAddressLine1 = delAddressLine1
        self.delAddressLine2 = delAddressLine2
        self.delAddressLine3 = delAddressLine3
        self.delCity = delCity
        self.delStateCode = delStateCode
        self.delPostCode = delPostCode
        self.delFullAddress = delFullAddress
        self.delContactperson = delContactperson
        self.delContactemail = delContactemail
        self.delPhone = delPhone
        self.document = document
        self.comments = comments
        self.notes = notes
        self.type = type
        self.status = status
        self.latitude = latitude
        self.longitude = longitude
        self.customOrder = customOrder
        self.isDeleted = isDeleted
        self.branch = branch
        self.jobStatus = jobStatus
        self.customerID = customerID
        self.driverSign = driverSign
        self.supervisonSign = supervisonSign
        self.customerSign = customerSign
        self.customerPhotos = customerPhotos
        self.deliveryComment = deliveryComment
        self.selectedJob = selectedJob
        self.ETAStatus = ETAStatus
        self.deliveryStatus = deliveryStatus
    }
    
    required override init() {
    }
    
    func toSubmitJobRquest() -> JobSubmitRequest {
        var request = JobSubmitRequest()
        request.jobID = id
        if let driverSign {
            request.driverSign = driverSign.base64EncodedString(options: .lineLength64Characters)
        }
        if let supervisonSign {
            request.supervisorSign = supervisonSign.base64EncodedString(options: .lineLength64Characters)
        }
        return request
    }
}

enum StatusString: String {
    case jobConfirm
    case ETA
    case delay
}

enum ETAString: String {
    case eta
    case delay
}
