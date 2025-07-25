import UIKit
import Combine
import CoreLocation

public enum UpdateETAViewState {
    case LocationPermission
    case success
    case error(String)
}

final class MyDeliveriesListViewModel {
    
    let configuration: MyDeliveriesList.Configuration
    @Published var jobList: [JobDisplayModel]?
    let fetchManager: LocalDataBaseWraper = LocalDataBaseWraper()
    
    init(configuration: MyDeliveriesList.Configuration) {
        self.configuration = configuration
    }
    
    func fetchDefaultList() {
        jobList = fetchManager.fetchJobsForDeliveryList().map { $0.mapToJobConfirmDisplay() }
    }

    func sortBasedOnDistance() {
        jobList = fetchManager.fetchJobsForDeliveryList().map {
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
        jobList = fetchManager.fetchJobsForDeliveryList().map {$0.mapToJobConfirmDisplay(distance: 0)  }.sorted(by: { $0.job.jobSequance < $1.job.jobSequance })
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

extension MyDeliveriesListViewModel {
    enum JobDisplayOption: String, Codable {
        case defaultView = "Default"
        case optimizedRoute = "Optimise Route"
        case dragAndDrop = "Drag & Drop"
    }
}
