
import UIKit

final class ResetPasswordViewModel {
    let configuration: ResetPassword.Configuration
    let customer: Customer
    
    init(configuration: ResetPassword.Configuration, customer: Customer) {
        self.configuration = configuration
        self.customer = customer
    }
        
}
