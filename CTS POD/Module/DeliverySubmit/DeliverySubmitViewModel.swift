
import UIKit
import Combine

final class DeliverySubmitViewModel {
    
    let jobs: [Job]
    let configuration: DeliverySubmit.Configuration
    let usecase: JobSubmitUseCaseProtocol
    @Published var viewState: APIState<JobStatusUpdateResponse>?
    
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
            
            if let signature {
                request.customerSign = signature.base64EncodedString()
            }
            Task { @MainActor in
                do {
                    try await usecase.updateJobStatus(request: request) { result in
                        
                    }
                } catch {
                    
                }
            }
        }
    }
}
