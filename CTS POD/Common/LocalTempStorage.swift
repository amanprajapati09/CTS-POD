//
//  LocalTempStorage.swift
//  CTS POD
//
//  Created by Aman Prajapati on 8/20/23.
//

import Foundation

class LocalTempStorage {
    
    static func storeValuse<T: Codable>(inUserdefault value: T, key: String) {
        do {
            let data = try JSONEncoder().encode(value)
            UserDefaults.standard.set(value, forKey: key)
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
}
