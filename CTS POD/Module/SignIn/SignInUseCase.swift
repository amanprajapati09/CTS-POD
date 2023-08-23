
import Foundation

protocol SignInUseCaseProtocol {
    func signIn(loginRequest: LoginRequestModel, completion: @escaping (Result<LoginResponse, Error>)->()) async throws -> Void
}

final class SignInUseCase: SignInUseCaseProtocol {
    let client: SignInClientProtocol
    init(client: SignInClientProtocol) {
        self.client = client
    }
    
    func signIn(loginRequest: LoginRequestModel, completion: @escaping (Result<LoginResponse, Error>)->()) async throws -> Void  {
        return try await client.signIn(loginRequest: loginRequest, completion: completion)
    }
}

