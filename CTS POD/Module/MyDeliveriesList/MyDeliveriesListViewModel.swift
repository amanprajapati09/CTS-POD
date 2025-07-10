import UIKit
import Combine
import CoreLocation

enum UpdateETAViewState {
    case LocationPermission
    case success
    case error(String)
}

final class MyDeliveriesListViewModel {
    
    let configuration: MyDeliveriesList.Configuration
    @Published var jobList: [JobDisplayModel]?
    let fetchManager: LocalDataBaseWraper = LocalDataBaseWraper()
    
    @Published var state: UpdateETAViewState?
    
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
    
    func updateStatus(selectedJob: Job) {
        LocationManagerSwift.shared.updateLocation { latitude, longitude, status, error in
            guard error == nil else {                
                self.state = .LocationPermission
                return }
            self.callAPI(selectedJob: selectedJob, latitude: latitude, longitude: longitude)
        }
    }
    
    private func callAPI(selectedJob: Job, latitude: Double, longitude: Double) {
        Task { @MainActor in
            do {
                let eta = ETAReuqest(jobID: selectedJob.id,
                                     sourceLatitude: latitude,
                                     sourceLongitude: longitude,
                                     destinationLatitude: selectedJob.latitude ?? 0.0,
                                     destinationLongitude: selectedJob.longitude ?? 0.0,
                                     createdDate: Date().apiSupportedDate(),
                                     itemStatus: selectedJob.ETAStatus == nil ? 1 : 0)
                
                try await configuration.usecase.updateETAStatus(request: eta) { result in
                    switch result {
                    case .success(let response):
                        if response.status == "Success" {
                            LocalDataBaseWraper().updateEtaStatus(job: selectedJob, status: selectedJob.ETAStatus == nil ? ETAString.eta : ETAString.delay)
                            self.state = .success
                        } else {
                            self.state = .error(response.message)
                            ErrorLogManager.uploadErrorLog(apiName: "Job/SendETA", error: response.message)
                        }
                    case .failure(let error):
                        self.state = .error("Somthing went wrong")
                        ErrorLogManager.uploadErrorLog(apiName: "Job/SendETA", error: error.localizedDescription)
                    }
                }
            } catch {
                self.state = .error("Somthing went wrong")
            }
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
