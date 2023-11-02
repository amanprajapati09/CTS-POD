import Foundation

protocol ETAUseCaseProtocol {
    func updateETAStatus(request: ETAReuqest, completion: @escaping (Result<JobStatusUpdateResponse, Error>)->()) async throws -> Void
}

final class ETAUseCase: ETAUseCaseProtocol {
    
    let client: ETAClientProtocol
    init(client: ETAClientProtocol) {
        self.client = client
    }
    
    func updateETAStatus(request: ETAReuqest, completion: @escaping (Result<JobStatusUpdateResponse, Error>) -> ()) async throws {
        return try await client.updateETAStatus(requestModel: request, completion: completion)
    }
}
