
import Foundation

final class DeliverySubmitViewModel {
    
    let jobs: [Job]
    let configuration: DeliverySubmit.Configuration
    
    init(jobs: [Job], configuration: DeliverySubmit.Configuration) {
        self.jobs = jobs
        self.configuration = configuration
    }
    
    var orderTitle: String {
        if jobs.count == 1 {
            return jobs.first?.orderNumber ?? ""
        }
        return configuration.string.navigationTitle
    }
}
