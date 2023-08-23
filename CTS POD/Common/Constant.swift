
import UIKit

struct Constant {
    static let baseURL = "https://ctstestapi.cooksconnection.com.au/api/v1/"
    
    static var deviceID: String {
        return UIDevice.current.identifierForVendor!.uuidString
    }
    
    static var isLogin: Bool {
        return LocalTempStorage.getValue(fromUserDefault: LoginDetails.self, key: "user") != nil
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
}
