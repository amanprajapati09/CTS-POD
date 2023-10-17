        
import Foundation
import RealmSwift
import Realm

final class RealmManager {
    
    static let shared = RealmManager.init()
    
    var realm: Realm!
    
    init() {
        realm = try! Realm()
    }
    
    func printRealmPath() {
        print(Realm.Configuration.defaultConfiguration.fileURL!)
    }
    
    func clearDatabase() {
        try! realm.write {
            realm.deleteAll()
        }
    }
    
    func addAndUpdateObjectToRealm(realmObject: Object) {
        try! realm.write {
            realm.add(realmObject, update: .all)
        }
    }
    
    func addObject(realmObject: Object) {
        try! realm.write {
            realm.add(realmObject)
        }
    }
    
    func addAndUpdateObjectsToRealm(realmList: [Object]) {
        try! realm.write {
            realm.add(realmList, update: .all)
        }
    }
    
    func addObjects(realmList: [Object]) {
        try! realm.write {
            realm.add(realmList)
        }
    }
    
    func removeObectFromRealm(realmObject: [Object]) {
        try! realm.write {
            realm.delete(realmObject)
        }
    }
    
    func deleteTable(type: Object.Type)  {
        let value = realm.objects(type.self)
        try! realm.write {
            realm.delete(value)
        }
    }
    
    func deleteObjects(realmList: [Object]) {
        try! realm.write {
            realm.delete(realmList)
        }
    }
    
    func fetchList<T: Object>(type : T.Type) -> [T]? {
        return realm.objects(type).toArray(ofType: type)
    }
}

extension Results {
    func toArray<T>(ofType: T.Type) -> [T] {
        var array = [T]()
        for i in 0 ..< count {
            if let result = self[i] as? T {
                array.append(result)
            }
        }

        return array
    }
}
