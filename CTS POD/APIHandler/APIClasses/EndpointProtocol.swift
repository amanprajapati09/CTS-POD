
import Foundation

protocol EndpointConfiguration {
    var path: String { get }
    var method: RequestMethods { get }
    var body: Encodable? { get }
    var queryParam: [URLQueryItem]? { get }
}
