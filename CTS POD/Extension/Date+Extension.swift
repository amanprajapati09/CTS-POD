
import Foundation

extension Date {
    func getDiffrenceBetweenDates() -> Int {
        let difference = Calendar.current.dateComponents([.hour, .minute], from: self, to: Date())
        return difference.hour ?? 0
    }
}
