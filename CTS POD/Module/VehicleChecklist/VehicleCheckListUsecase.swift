
import Foundation


protocol VehicleCheckListUsecaseProtocol {
    func getCheckList(completion: @escaping (Result<VehicleCheckListResponse, Error>)->()) async throws -> Void
}

final class VehicleCheckListUsecase: VehicleCheckListUsecaseProtocol {
    let client: VehicleCheckListClientProtocol
    init(client: VehicleCheckListClientProtocol) {
        self.client = client
    }
    
    func getCheckList(completion: @escaping (Result<VehicleCheckListResponse, Error>) -> ()) async throws {
        return try await client.getCheckList(completion: completion)
    }
   
}
