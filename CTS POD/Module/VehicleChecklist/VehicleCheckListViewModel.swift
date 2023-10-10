
import Foundation

final class VehicleCheckListViewModel {
    
    let configuration: VehicleCheckList.Configuration
    var requestModel = VehicleStatusUpdateRequestModel()
    
    @Published var viewState: APIState<VehicleCheckListResponse>?
    @Published var updateViewState: APIState<UpdateStatusResult>?
    
    var vechicleCheckList: VehicleCheckListResponse?
    
    init(configuration: VehicleCheckList.Configuration) {
        self.configuration = configuration
    }
    
    func fetchCheckList()  {
        viewState = .loading
        Task { @MainActor in 
            do {
                try await configuration.usecase.getCheckList { result in
                    if let checklist = result.value {
                        self.viewState = .loaded(checklist)
                    }
                }
            } catch {
                viewState = .error("Somthing went wrong!")
            }
        }
    }
    
    func modifyStatus(item: CheckListItem) {
        if let index = requestModel.checklists.firstIndex(where: {$0.id == item.id }) {
            requestModel.checklists[index] = item
        } else {
            requestModel.checklists.append(item)
        }
        print(requestModel)
    }
    
    func updateStatus(status: String) {
        requestModel.createdDate = Date().createUTCDateString()
        requestModel.vehicleStatus = status
        Task { @MainActor in
            updateViewState = .loading
            do {
                try await configuration.usecase.updateVehicleStatus(request: requestModel, completion: { result in
                    if let value = result.value {
                        self.updateViewState = .loaded(value)
                        UserDefaults.standard.set(Date(), forKey: UserDefaultKeys.checkVehicle)
                    } else {
                        self.updateViewState = .error("Somthing went wrong!")
                    }
                })
            } catch {
                updateViewState = .error("Somthing went wrong!")
            }
        }
    }
}
