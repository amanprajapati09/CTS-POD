
import UIKit
import Combine
import CoreLocation
final class JobConfirmListViewModel {

    let configuration: JobConfirm.Configuration
    @Published var jobList: [JobDisplayModel]?
    let fetchManager: LocalDataBaseWraper = LocalDataBaseWraper()
    
    
    init(configuration: JobConfirm.Configuration) {
        self.configuration = configuration
        let fetchJobs = fetchManager.fetchUpdatedJobs()
        LocalDataBaseWraper().updateJobSequance(jobs: fetchJobs)
    }

    func fetchDefaultList() {
        jobList = fetchManager.fetchUpdatedJobs().map { $0.mapToJobConfirmDisplay() }
    }

    func sortBasedOnDistance() {
        jobList = fetchManager.fetchUpdatedJobs().map {
            if let currentLocation = LocationManager.sharedInstance.currentLocation,
               let latitude = $0.latitude,
               let longitude = $0.longitude {
                let jobLocation = CLLocation(latitude: latitude, longitude: longitude)
                let distance = currentLocation.distance(from: jobLocation)
                return $0.mapToJobConfirmDisplay(distance: distance)
            }else {
                return $0.mapToJobConfirmDisplay(distance: 0)
            }
        }.sorted(by: { $0.distance < $1.distance })
    }

    func sortBasedOnPosition() {
        jobList = fetchManager.fetchUpdatedJobs().map {$0.mapToJobConfirmDisplay(distance: 0)  }.sorted(by: { $0.job.jobSequance < $1.job.jobSequance })
    }

    func fetchList(option: JobDisplayOption) {
        switch option {
        case .defaultView:
            fetchDefaultList()
        case .optimizedRoute:
            sortBasedOnDistance()
        case .dragAndDrop:
            sortBasedOnPosition()
        }
    }
}

extension JobConfirmListViewModel {
    enum JobDisplayOption: String, Codable {
        case defaultView = "Default"
        case optimizedRoute = "Optimise Route"
        case dragAndDrop = "Drag & Drop"
    }
}
