
import UIKit
import Combine

final class DeliverySubmitViewModel {
    
    let jobs: [Job]
    let configuration: DeliverySubmit.Configuration
    let usecase: JobSubmitUseCaseProtocol
    @Published var viewState: APIState<JobStatusUpdateResponse>?
    let myGroup = DispatchGroup()
    
    init(jobs: [Job], configuration: DeliverySubmit.Configuration, usecase: JobSubmitUseCaseProtocol = JobSubmitUseCase(client: JobSubmitClient())) {
        self.jobs = jobs
        self.configuration = configuration
        self.usecase = usecase
    }
    
    var orderTitle: String {
        if jobs.count == 1 {
            return jobs.first?.orderNumber ?? ""
        }
        return configuration.string.navigationTitle
    }
    
    var orderNumber: String {
        if jobs.count == 1 {
            return jobs.first?.deliveryNo ?? ""
        }
        return configuration.string.navigationTitle
    }
    
    func submitJob(comment: String, name: String, images: [UIImage]?, status: DeliveryOption, signature: Data?)  {
        viewState = .loading
        for job in jobs {
            let request = job.toSubmitJobRquest()
            request.comments = comment
            request.customerName = name
            if let images {
                for (index, image) in images.enumerated() {
                    guard let data = image.base64String else {return}
                    switch index {
                    case 0:
                        request.image1 = data
                    case 1:
                        request.image2 = data
                    case 2:
                        request.image3 = data
                    case 3:
                        request.image4 = data
                    default:
                        request.image5 = data
                    }
                }
            }
            request.status = status.status
            request.modifiedTime = Date().apiSupportedDate()
            request.userID = LocalTempStorage.getValue(fromUserDefault: LoginDetails.self, key: UserDefaultKeys.user)?.id ?? "0"
            if let signature {
                request.customerSign = signature.base64EncodedString()
            }
            LocationManagerSwift.shared.updateLocation { latitude, longitude, status, error in
                guard error == nil else {
                    self.viewState = .error("Please enable location permission from settings")
                    return
                }
                request.latitude = latitude
                request.longitude = longitude
                self.myGroup.enter()
                self.callAPI(request: request)
            }
            
        }
        myGroup.notify(queue: DispatchQueue.main, execute: {
            self.viewState = .loaded(JobStatusUpdateResponse(status: "Done", message: "Success"))
            self.updateJobStatus()
        })
    }
    
    private func callAPI(request: JobSubmitRequest) {
        Task { @MainActor in
            do {
                try await usecase.updateJobStatus(request: request) { result in
                    self.myGroup.leave()
                    switch result {
                    case .success(_):
                        break
                    default:
                        self.viewState = .error("Something went wrong")
                    }
                }
            } catch {
                self.viewState = .error("Something went wrong")
            }
        }
    }
    
    private func updateJobStatus() {
        do {
            try RealmManager.shared.realm.write {
                for job in jobs {
                    job.jobStatus = StatusString.submited.rawValue
                }
            }
        } catch {}
    }
}
