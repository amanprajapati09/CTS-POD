
import Foundation

protocol IncidentReportUsecaseProtocol {
    func fetchDynamicReport(completion: @escaping (Result<IncidentRepostResponseModel, Error>)->()) async throws -> Void
    func postDynamicReport(requestModel:IncidentReportRequestModel, completion: @escaping (Result<IncidentReportResultModel, Error>)->()) async throws -> Void
    func uploadDynamicReportImage(requestModel: IncidentPhotoModel, completion: @escaping (Result<JobStatusUpdateResponse, Error>)->()) async throws -> Void
}

final class IncidentReportUsecase: IncidentReportUsecaseProtocol {
    
    let client: IncidentReportClient
    init(client: IncidentReportClient) {
        self.client = client
    }
    
    func fetchDynamicReport(completion: @escaping (Result<IncidentRepostResponseModel, Error>) -> ()) async throws {
        return try await client.fetchDynamicReport(completion: completion)
    }
    
    func postDynamicReport(requestModel: IncidentReportRequestModel, completion: @escaping (Result<IncidentReportResultModel, Error>) -> ()) async throws {
        return try await client.postDynamicReport(requestModel: requestModel, completion: completion)
    }
    
    func uploadDynamicReportImage(requestModel: IncidentPhotoModel, completion: @escaping (Result<JobStatusUpdateResponse, Error>) -> ()) async throws {
        return try await client.uploadDynamicReportImage(requestModel: requestModel, completion: completion)
    }
}
