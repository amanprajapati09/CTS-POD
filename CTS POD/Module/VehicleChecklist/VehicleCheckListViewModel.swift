
import Foundation

final class VehicleCheckListViewModel {
    
    let configuration: VehicleCheckList.Configuration
    
    @Published var viewState: APIState<VehicleCheckListResponse>?
    var vechicleCheckList: VehicleCheckListResponse?
    
    init(configuration: VehicleCheckList.Configuration) {
        self.configuration = configuration
    }
    
    func fetchCheckList()  {
        viewState = .loading
        Task {
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
}
