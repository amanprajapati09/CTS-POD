
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

protocol JobReSubmitUseCaseProtocol {
    func updateJobStatus(request: JobSubmitResendRequest, completion: @escaping (Result<JobStatusUpdateResponse, Error>)->()) async throws -> Void
}

final class JobReSubmitUseCase: JobReSubmitUseCaseProtocol {
    
    let client: JobReSubmitClientProtocol
    init(client: JobReSubmitClientProtocol) {
        self.client = client
    }
    
    func updateJobStatus(request: JobSubmitResendRequest, completion: @escaping (Result<JobStatusUpdateResponse, Error>) -> ()) async throws {
        return try await client.updateJobStatus(requestModel: request, completion: completion)
    }
}
