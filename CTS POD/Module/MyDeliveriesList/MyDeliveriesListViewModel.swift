import UIKit
import Combine

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
    
    func fetchList() {
        jobList = fetchManager.fetchJobsForDeliveryList().map { $0.mapToJobConfirmDisplay() }
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
