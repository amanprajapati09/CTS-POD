
import Foundation

protocol SignInUseCaseProtocol {
    func signIn(loginRequest: LoginRequestModel, completion: @escaping (Result<LoginResponse, Error>)->()) async throws -> Void
    func generateOTP(forgotPasswordRequest: ForgotPasswordRequest, completion: @escaping(Result<ForgotPasswordResponse, Error>)->())  async throws -> Void
    func validateOTP(validateOTPRequest: ValidateOTPRequest, completion: @escaping(Result<ForgotPasswordResponse, Error>)->())  async throws -> Void
    func resetPassword(resetPassword: ResetPasswordRequest, completion: @escaping(Result<ResetPasswordResponse, Error>)->())  async throws -> Void
}

final class SignInUseCase: SignInUseCaseProtocol {
    let client: SignInClientProtocol
    init(client: SignInClientProtocol) {
        self.client = client
    }
    
    func signIn(loginRequest: LoginRequestModel, completion: @escaping (Result<LoginResponse, Error>)->()) async throws -> Void  {
        return try await client.signIn(loginRequest: loginRequest, completion: completion)
    }
    
    func generateOTP(forgotPasswordRequest: ForgotPasswordRequest, completion: @escaping(Result<ForgotPasswordResponse, Error>)->())  async throws -> Void {
        return try await client.generateOTP(forgotPasswordRequest: forgotPasswordRequest, completion: completion)
    }
    
    func validateOTP(validateOTPRequest: ValidateOTPRequest, completion: @escaping(Result<ForgotPasswordResponse, Error>)->())  async throws -> Void {
        return try await client.validateOTP(validateOTPRequest: validateOTPRequest, completion: completion)
    }
    
    func resetPassword(resetPassword: ResetPasswordRequest, completion: @escaping(Result<ResetPasswordResponse, Error>)->())  async throws -> Void {
        return try await client.resetPassword(resetPassword: resetPassword, completion: completion)
    }
}

