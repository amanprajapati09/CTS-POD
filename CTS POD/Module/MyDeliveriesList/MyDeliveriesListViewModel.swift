import UIKit
import Combine
final class MyDeliveriesListViewModel {

    let configuration: MyDeliveriesList.Configuration
    @Published var jobList: [JobDisplayModel]?
    let fetchManager: LocalDataBaseWraper = LocalDataBaseWraper()
    
    
    init(configuration: MyDeliveriesList.Configuration) {
        self.configuration = configuration
    }
    
    func fetchList() {
        jobList = fetchManager.fetchJobsForDeliveryList().map { $0.mapToJobConfirmDisplay() }
    }
}
