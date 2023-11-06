
import Foundation

protocol JobConfirmUseCaseProtocol {
    func fetchJob(completion: @escaping (Result<JobConfirmResponse, Error>)->()) async throws -> Void
    func updateJob(request: JobStatusUpdate, completion: @escaping (Result<JobStatusUpdateResponse, Error>)->()) async throws -> Void
}

final class JobConfirmUseCase: JobConfirmUseCaseProtocol {
    let client: JobConfirmClientProtocol
    init(client: JobConfirmClientProtocol) {
        self.client = client
    }
    
    func fetchJob(completion: @escaping (Result<JobConfirmResponse, Error>) -> ()) async throws {
        return try await client.fetchJob(completion: completion)
    }
    
    func updateJob(request: JobStatusUpdate, completion: @escaping (Result<JobStatusUpdateResponse, Error>) -> ()) async throws {
        return try await client.updateJob(request: request, completion: completion)
    }
}
