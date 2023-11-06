
import Foundation

struct ETAReuqest: Codable {
    let jobID: String
    let sourceLatitude: Double
    let sourceLongitude: Double
    let destinationLatitude: Double
    let destinationLongitude: Double
    let createdDate: String
    let itemStatus: Int
}
