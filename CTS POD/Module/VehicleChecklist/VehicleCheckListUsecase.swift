
import Foundation


protocol VehicleCheckListUsecaseProtocol {
    func getCheckList(completion: @escaping (Result<VehicleCheckListResponse, Error>)->()) async throws -> Void
    func updateVehicleStatus(request: VehicleStatusUpdateRequestModel, completion: @escaping (Result<UpdateStatusResult, Error>)->()) async throws -> Void
}

final class VehicleCheckListUsecase: VehicleCheckListUsecaseProtocol {
    let client: VehicleCheckListClientProtocol
    init(client: VehicleCheckListClientProtocol) {
        self.client = client
    }
    
    func getCheckList(completion: @escaping (Result<VehicleCheckListResponse, Error>) -> ()) async throws {
        return try await client.getCheckList(completion: completion)
    }
   
    func updateVehicleStatus(request: VehicleStatusUpdateRequestModel, completion: @escaping (Result<UpdateStatusResult, Error>)->()) async throws -> Void {
        return try await client.updateVehicleStatus(request: request, completion: completion)
    }
}
