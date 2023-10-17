
import Foundation

struct JobStatusUpdate: Encodable {
    let ids: [String]
    let status: Int
    let branchCode: String
}

struct JobStatusUpdateResponse: Decodable {
    let status, message: String
}
