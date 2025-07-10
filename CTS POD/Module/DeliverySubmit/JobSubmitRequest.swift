import RealmSwift
import Foundation

class JobSubmitRequest: Object, Codable {
    @Persisted var jobs = List<JobRequest>()
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
    @Persisted var batchID: String
    
    enum CodingKeys: String, CodingKey {
        case jobs
        case userID = "userId"
        case driverSign, supervisorSign, customerSign, comments, image1, image2, image3, image4, image5, status, customerName, modifiedTime, latitude, longitude
        case batchID = "batchId"
    }
    
    func makeCopy() -> JobSubmitRequest {
        let newObject = JobSubmitRequest()
        for job in jobs {
            newObject.jobs.append(job.getDuplicateObject())
        }
        newObject.userID = userID
        newObject.driverSign = driverSign
        newObject.supervisorSign = supervisorSign
        newObject.customerSign = customerSign
        newObject.comments = comments
        newObject.image1 = image1
        newObject.image2 = image2
        newObject.image3 = image3
        newObject.image4 = image4
        newObject.image5 = image5
        newObject.status = status
        newObject.customerName = customerName
        newObject.modifiedTime = modifiedTime
        newObject.latitude = latitude
        newObject.longitude = longitude
        newObject.batchID = batchID
        return newObject
    }

}

class JobRequest: Object, Codable {
    @Persisted var jobID: String
    @Persisted var driverSign: String
    @Persisted var supervisorSign: String
    @Persisted var recordType: String
    
    enum CodingKeys: String, CodingKey {
        case jobID = "jobId"
        case driverSign, supervisorSign, recordType
    }
    
    func getDuplicateObject() -> JobRequest {
        let newObject = JobRequest()
        newObject.jobID = jobID
        newObject.driverSign = driverSign
        newObject.supervisorSign = supervisorSign
        newObject.recordType = recordType
        return newObject
    }
}
