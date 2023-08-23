
import Foundation

final class SharedObject {
    public static let shared = SharedObject()
    private init() {}
    
    var customer: Customer?
}
