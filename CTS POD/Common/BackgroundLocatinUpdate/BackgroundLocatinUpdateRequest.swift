import Foundation

struct BackgroundLocatinUpdateRequest: Codable {
    let latitude: Double
    let longitude: Double
    let address: String
    let createdDate: String
}

struct BackgroundLocatinUpdateResponse: Codable {
    let latitude: String
    let longitude: Double
    let address: String
    let createdDate: String
}
