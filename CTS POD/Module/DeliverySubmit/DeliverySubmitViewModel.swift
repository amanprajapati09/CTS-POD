
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
    
    func submitJob(comment: String, 
                   name: String,
                   images: [UIImage]?,
                   statusOption: DeliveryOption,
                   signature: Data?)  {
        
        var requestModelList = [JobSubmitRequest]()
        
        for job in jobs {
            
            LocationManagerSwift.shared.updateLocation { latitude, longitude, status, error in
                guard error == nil else {
                    self.viewState = .error("Please enable location permission from settings")
                    return
                }
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
                request.status = statusOption.status
                request.modifiedTime = Date().apiSupportedDate()
                request.userID = LocalTempStorage.getValue(fromUserDefault: LoginDetails.self, key: UserDefaultKeys.user)?.id ?? "0"
                if let signature {
                    request.customerSign = signature.base64EncodedString()
                }
                request.latitude = latitude
                request.longitude = longitude
                requestModelList.append(request)
                DispatchQueue.main.async {
                    self.viewState = .loading
                    self.manageAPICallingIndex(list: requestModelList, index: 0)
                }
            }
        }
    }
    
    private func manageAPICallingIndex(list: [JobSubmitRequest], index: Int) {
        guard index < jobs.count else {
            self.updateJobStatus()
            self.viewState = .loaded(JobStatusUpdateResponse(status: "Done", message: "Success"))
            return
        }
        let requestModel = list[index]
        callAPI(request: requestModel) { isSuccess in
            if isSuccess {
                self.manageAPICallingIndex(list: list, index: (index + 1))
            } else {
                self.viewState = .error("Somthing went wrong! \nPlease try again!")
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
            RealmManager.shared.addAndUpdateObjectToRealm(realmObject: request)
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
