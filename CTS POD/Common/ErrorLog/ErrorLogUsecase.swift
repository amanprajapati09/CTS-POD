//
//  ErrorLogUsecase.swift
//  CTS POD
//
//  Created by Aman Prajapati on 25/11/23.
//

import Foundation

protocol ErrorLogUsecaseProtocol {
    func logError(request: ErrorLogReqModel, completion: @escaping (Result<JobStatusUpdateResponse, Error>)->()) async throws -> Void
}

final class ErrorLogUsecase: ErrorLogUsecaseProtocol {
    
    let client: ErrorLogClient
    init(client: ErrorLogClient) {
        self.client = client
    }
    
    func logError(request: ErrorLogReqModel, completion: @escaping (Result<JobStatusUpdateResponse, Error>) -> ()) async throws {
        return try await client.logError(requestModel: request, completion: completion)
    }
}
