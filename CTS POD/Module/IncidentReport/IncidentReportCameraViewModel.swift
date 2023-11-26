
import UIKit
import Combine

final class IncidentReportCameraViewModel {
    let configuration: IncidentReport.Configuration
    @Published var viewState: APIState<Bool>?
    
    init(configuration: IncidentReport.Configuration) {
        self.configuration = configuration        
    }
    
    func callIncidentReportAPI(requestModel: IncidentReportRequestModel, collectionImages: [UIImage])  {
        Task{@MainActor in
            do {
                viewState = .loading
                try await configuration.usecase.postDynamicReport(requestModel: requestModel) { result in
                    switch result {
                    case .success(let response):
                        if response.status == "Success" {
                            self.uploadImages(collectionImages: collectionImages, incidentId: response.data.IncidentId, index: 0)
                        } else {
                            self.viewState = .error(response.message)
                            ErrorLogManager.uploadErrorLog(apiName: "DynamicIncidentReport/PostReportDetails", error: response.message)
                        }
                    case .failure(let error):
                        self.viewState = .error(error.localizedDescription)
                        ErrorLogManager.uploadErrorLog(apiName: "DynamicIncidentReport/PostReportDetails", error: error.localizedDescription)
                    }
                }
            } catch {
                viewState = .error("Somthing went wrong")
            }
        }
    }
    
    func uploadImages(collectionImages: [UIImage], incidentId: Int, index: Int)  {
        Task{@MainActor in
            do {
                guard index < collectionImages.count else {
                    viewState = .loaded(true)
                    return
                }
                guard let imageData = collectionImages[index].base64String else { return }
                let request = IncidentPhotoModel(incidentID: incidentId,
                                                 photo: imageData,
                                                 isLandscap: false)
                try await configuration.usecase.uploadDynamicReportImage(requestModel: request, completion: { result in
                    switch result {
                    case .success(let response):
                        if response.status == "Success" {
                            self.uploadImages(collectionImages: collectionImages, incidentId: incidentId, index: index + 1)
                        } else {
                            ErrorLogManager.uploadErrorLog(apiName: "Incident/AddPhoto", error: response.message)
                        }
                    case .failure(let error):
                        self.viewState = .error(error.localizedDescription)
                        ErrorLogManager.uploadErrorLog(apiName: "Incident/AddPhoto", error: error.localizedDescription)
                    }
                })
            } catch {
                viewState = .error("Unable to upload image please connect with admin.")
            }
        }
    }
}

