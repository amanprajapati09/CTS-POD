import Foundation

protocol ETAClientProtocol {
    func updateETAStatus(request: ETAReuqest, completion: @escaping (Result<JobConfirmResponse, Error>)->()) async throws -> Void
}

