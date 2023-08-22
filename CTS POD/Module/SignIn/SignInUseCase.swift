//
//  SignInUseCase.swift
//  CTS POD
//
//  Created by jayesh kanzariya on 21/08/23.
//

import Foundation

protocol SignInUseCaseProtocol {
    func signIn(username: String, password: String, completion: @escaping (Result<CustomerResult, Error>)->()) async throws -> Void
}

final class SignInUseCase: SignInUseCaseProtocol {
    let client: SignInClientProtocol
    init(client: SignInClientProtocol) {
        self.client = client
    }
    
    func signIn(username: String, password: String, completion: @escaping (Result<CustomerResult, Error>)->()) async throws -> Void  {
        return try await client.signIn(username: username, password: password, completion: completion)
    }
}

