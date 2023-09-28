import UIKit

enum PreferancesKey : String{
    case userInformation = "UserInformation"
}

final class Preferances {

    /**
        This method is used to setvalue in User Default
    */
    final class func setValue(value : Any,key : PreferancesKey){
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: value, requiringSecureCoding: false)
            UserDefaults.standard.setValue(data, forKey: key.rawValue)
            UserDefaults.standard.synchronize()
        }
        catch (let error) {
            print(error)
        }
    }

    /**
        This method is used to getValueFrom User Default
    */
    final class func getValue(key : PreferancesKey) -> Any? {
        guard let data = getValueInData(key: key) else {
            return nil
        }
        do {
            let value = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data)
            return value
        }
        catch(let error) {
            return nil
        }
    }
    
    /**
     This method is used to remove value from User Default
    */
    final class func removeObject(key : PreferancesKey) {
        UserDefaults.standard.removeObject(forKey: key.rawValue)
        UserDefaults.standard.synchronize()
    }
    
    /**
     This method is used to get value in data
     */
    private final class func getValueInData(key : PreferancesKey) -> Data?{
        return UserDefaults.standard.value(forKey: key.rawValue) as? Data
    }

}

extension Preferances {
    
    /**
       This method is used to store codable models
     */
    final class func setClassObject<T: Codable>(_ value: T?, forKey defaultName: PreferancesKey) {
        do {
            let data = try JSONEncoder().encode(value)
            UserDefaults.standard.set(data, forKey: defaultName.rawValue)
        }
        catch(let error){
            assertionFailure(error.localizedDescription)
        }
    }
    
    /**
        This method is used to get codable models
     */
    final class func getClassObject<T>(forKey defaultName: PreferancesKey) -> T? where T : Decodable {
        guard let encodedData = UserDefaults.standard.data(forKey: defaultName.rawValue) else {
            return nil
        }
        do{
            return try JSONDecoder().decode(T.self, from: encodedData)
        }
        catch(let error){
            print(error.localizedDescription)
            return nil
        }
    }
}
