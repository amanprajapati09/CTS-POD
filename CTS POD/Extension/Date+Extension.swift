
import Foundation

extension Date {
    func getDiffrenceBetweenDates() -> Int {
        let difference = Calendar.current.dateComponents([.hour, .minute], from: self, to: Date())
        return difference.hour ?? 0
    }
    
    func createUTCDateString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone(identifier: "UTC")
        return formatter.string(from: self)
    }
    
    func apiSupportedDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"                                
        formatter.timeZone = TimeZone(identifier: "UTC")
        let string = formatter.string(from: self).components(separatedBy: "+")[0]
        return "\(string)Z"
    }
}
