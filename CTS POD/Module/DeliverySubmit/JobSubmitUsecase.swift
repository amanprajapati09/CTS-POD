
import Foundation

protocol JobSubmitUseCaseProtocol {
    func updateJobStatus(request: JobSubmitRequest, completion: @escaping (Result<JobStatusUpdateResponse, Error>)->()) async throws -> Void
}

final class JobSubmitUseCase: JobSubmitUseCaseProtocol {
    
    let client: JobSubmitClientProtocol
    init(client: JobSubmitClientProtocol) {
        self.client = client
    }
    
    func updateJobStatus(request: JobSubmitRequest, completion: @escaping (Result<JobStatusUpdateResponse, Error>) -> ()) async throws {
        return try await client.updateJobStatus(requestModel: request, completion: completion)
    }
}
