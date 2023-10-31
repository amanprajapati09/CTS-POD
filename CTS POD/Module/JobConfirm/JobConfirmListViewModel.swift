
import UIKit
import Combine
final class JobConfirmListViewModel {

    let configuration: JobConfirm.Configuration
    @Published var jobList: [JobDisplayModel]?
    let fetchManager: LocalDataBaseWraper = LocalDataBaseWraper()
    
    
    init(configuration: JobConfirm.Configuration) {
        self.configuration = configuration
    }
    
    func fetchList() {
        jobList = fetchManager.fetchUpdatedJobs().map { $0.mapToJobConfirmDisplay() }
    }
}
