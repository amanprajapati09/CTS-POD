
import Foundation

enum SignatureType {
    case driverSign
    case supervisorSign
}

final class SignViewModel {
    let configuration: Signature.Configuration
    let signType: SignatureType
    var complition: ((_ sign: Data)->())?
    
    init(configuration: Signature.Configuration, signType: SignatureType) {
        self.configuration = configuration
        self.signType = signType
    }
    
    func updateJobs(signData: Data)  {
        complition?(signData)
    }
}
