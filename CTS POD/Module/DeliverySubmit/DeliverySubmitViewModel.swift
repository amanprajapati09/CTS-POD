
import UIKit
import Combine

final class DeliverySubmitViewModel {
    
    let jobs: [Job]
    let configuration: DeliverySubmit.Configuration
    let usecase: JobSubmitUseCaseProtocol
    @Published var viewState: APIState<JobStatusUpdateResponse>?
    
    let networkCheck = NetworkCheck.sharedInstance()
    
    init(jobs: [Job], configuration: DeliverySubmit.Configuration, usecase: JobSubmitUseCaseProtocol = JobSubmitUseCase(client: JobSubmitClient())) {
        self.jobs = jobs
        self.configuration = configuration
        self.usecase = usecase
    }
    
    var orderTitle: String {
        if jobs.count == 1 {
            return configuration.string.navigationTitle + " " + (jobs.first?.orderNumber ?? "")
        }
        return configuration.string.navigationTitle
    }
    
    var orderNumber: String {
        if jobs.count == 1 {
            return jobs.first?.deliveryNo ?? ""
        }
        return configuration.string.navigationTitle
    }
    
    func submitJob(comment: String,
                   name: String,
                   images: [UIImage]?,
                   statusOption: DeliveryOption,
                   signature: Data?)  {
        
        let request = JobSubmitRequest()
        let user = LocalTempStorage.getValue(fromUserDefault: LoginDetails.self, key: UserDefaultKeys.user)
        LocationManagerSwift.shared.updateLocation { latitude, longitude, status, error in
            guard error == nil else {
                self.viewState = .error("Please enable location permission from settings")
                return
            }
            
            for (index,job) in self.jobs.enumerated() {
                if index == 0 {
                    request.jobs.append(job.toSubmitJobRquest(recordType: "M"))
                } else {
                    request.jobs.append(job.toSubmitJobRquest(recordType: "S"))
                }
            }
            
            request.comments = comment
            request.customerName = name
            if let images {
                for (index, image) in images.enumerated() {
                    guard let data = image.resizeAndConvertToBase64(resolution: (user?.user.getResolution ?? .high)) else {return}
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
            request.status = statusOption.status
            request.modifiedTime = Date().apiSupportedDate()
            request.userID = user?.id ?? "0"
            if let signature {
                request.customerSign = signature.base64EncodedString(options: .lineLength64Characters)
            }
            request.latitude = latitude
            request.longitude = longitude
            request.batchID = UUID().uuidString
            DispatchQueue.main.async {
                self.viewState = .loading
                self.callAPI(request: request) { isSuccess in
                    if isSuccess {
                        self.updateJobStatus()
                        self.viewState = .loaded(JobStatusUpdateResponse(status: "Done", message: "Success"))
                    } else {
                        self.viewState = .error("Somthing went wrong! \nPlease try again!")
                    }
                }
            }
        }
    }
    
    private func callAPI(request: JobSubmitRequest, complition: @escaping ((_ isSuccess: Bool)->Void)) {
        if networkCheck.currentStatus == .satisfied {
            Task { @MainActor in
                do {
                    try await usecase.updateJobStatus(request: request) { result in
                        switch result {
                        case .success(let value):
                            if value.status == "Success" {
                                complition(true)
                            } else {
                                complition(false)
                                ErrorLogManager.uploadErrorLog(apiName: "Job/AddOrUpdateJobDocument", error: value.message)
                            }
                        case .failure(let error):
                            complition(false)
                            ErrorLogManager.uploadErrorLog(apiName: "Job/AddOrUpdateJobDocument", error: error.localizedDescription)
                        }
                    }
                } catch (let error) {
                    print(error)
                    complition(false)
                }
            }
        } else {
            RealmManager.shared.addObject(realmObject: request)
            complition(true)
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
