import RealmSwift
import Foundation

class JobSubmitRequest: Object, Codable {
    @Persisted var jobID: String
    @Persisted var userID: String
    @Persisted var driverSign: String
    @Persisted var supervisorSign: String
    @Persisted var customerSign: String?
    @Persisted var comments: String
    @Persisted var image1: String?
    @Persisted var image2: String?
    @Persisted var image3: String?
    @Persisted var image4: String?
    @Persisted var image5: String?
    @Persisted var status: Int
    @Persisted var customerName: String
    @Persisted var modifiedTime: String
    @Persisted var latitude: Double
    @Persisted var longitude: Double

    enum CodingKeys: String, CodingKey {
        case jobID = "jobId"
        case userID = "userId"
        case driverSign, supervisorSign, customerSign, comments, image1, image2, image3, image4, image5, status, customerName, modifiedTime, latitude, longitude
    }
}

