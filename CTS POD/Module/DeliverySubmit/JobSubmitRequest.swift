import RealmSwift
import Foundation

class JobSubmitRequest: Object, Codable {
    var jobID, userID, driverSign, supervisorSign: String
    var customerSign, comments, image1, image2: String
    var image3, image4, image5: String
    var status: Int
    var customerName, modifiedTime: String
    var latitude, longitude: Int

    enum CodingKeys: String, CodingKey {
        case jobID = "jobId"
        case userID = "userId"
        case driverSign, supervisorSign, customerSign, comments, image1, image2, image3, image4, image5, status, customerName, modifiedTime, latitude, longitude
    }
}

