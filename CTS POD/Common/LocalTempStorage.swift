
import Foundation

class LocalTempStorage {
    
    static func storeValue(inUserdefault value: Codable, key: String) {
        do {
            let data = try JSONEncoder().encode(value)
            UserDefaults.standard.set(data, forKey: key)
        } catch {
            print("Error in storage")
        }
    }
    
    static func getValue<T: Codable>(fromUserDefault type: T.Type, key: String) -> T? {
        if let data = UserDefaults.standard.data(forKey: key) {
            do {
                let data = try JSONDecoder().decode(T.self, from: data)
                return data
            } catch {
                return nil
            }
        } else {
            return nil
        }
    }
    
    static func removeValue(for key: String) {
        UserDefaults.standard.set(nil, forKey: key)
    }
}
