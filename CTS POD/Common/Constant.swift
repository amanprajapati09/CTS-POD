
import UIKit

struct Constant {
    static let baseURL = "https://ctstestapi.cooksconnection.com.au/api/v1/"
    
    static var deviceID: String {
        return UserDefaults.standard.string(forKey: UserDefaultKeys.fcmToke) ?? UIDevice.current.identifierForVendor!.uuidString
    }
    
    static var isLogin: Bool {
        return LocalTempStorage.getValue(fromUserDefault: LoginDetails.self, key: UserDefaultKeys.user) != nil
    }
    
    static var isVehicalCheck: Bool {        
        if Constant.isLogin {
            if let date = UserDefaults.standard.value(forKey: UserDefaultKeys.checkVehicle) as? Date {
                if date.days(from: Date()) > 0 {
                    return true
                }
                return false
            } else {
                return true
            }
        }
        return false
    }
}

struct Colors {
    
    static let colorPrimary = UIColor(hex:"#009CA6")
    
    static let colorPrimaryDark = UIColor(hex:"#00767E")
    
    static let colorAccent = UIColor(hex:"#00767E")
    
    static let colordisable = UIColor(hex:"#90009CA6")
    
    static let colorBlack = UIColor(hex:"#000000")
    
    static let colortext = UIColor(hex:"#009BA6")
    
    static let colorBlue = UIColor(hex:"#3699FF")
    
    static let colorsignin = UIColor(hex:"#81d8d0")
    
    static let colorGreen = UIColor(hex:"#228c22")
    
    static let colororagne = UIColor(hex:"#FDA500")
    
    static let colorred = UIColor(hex:"#c21807")
    
    static let colorGray = UIColor(hex:"#ADACBA")
    
    static let colorLightGray = UIColor(hex:"#D3D3D3")
    
    static let coloredittext = UIColor(hex:"#F3F7FA")
    
    static let colorWhite = UIColor(hex:"#FFFFFF")
    
    static let colorCall = UIColor(hex:"#1AC5BC")
    
    static let colorNavigate = UIColor(hex:"#3699FF")
    
    static let colorPreview = UIColor(hex:"#FFA800")
    
    static let transparent = UIColor(hex:"#00000000")
    
    static let colortransparentGray = UIColor(hex:"#90D3D3")
    
    static let viewBackground = UIColor(hex:"#F9F9F9")
    
    static let forgotPasswordViewBackground = UIColor(hex:"#FAFAFA")
}

struct UserDefaultKeys {
    static let user = "user"
    static let customer = "customers"
    static let checkVehicle = "checkVehicle"
    static let isVehicalSubmit = "VehicalSubmit"
    static let fcmToke = "fcmToken"
    static let lastTimeStampUpdateLocation = "lastTimeStampUpdateLocation"
}
