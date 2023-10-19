
import UIKit
import Combine

final class DashboardViewModel {
    let configuration: Dashboard.Configuration
    let customer: Customer
    let fetchManager = LocalDataBaseWraper()
    
    @Published var canShowFetchButton: Bool = true
    @Published var updateJobListComplete: Bool = false
    
    private var jobList = [Job]()
    
    init(configuration: Dashboard.Configuration, customer: Customer) {
        self.configuration = configuration
        self.customer = customer
    }
    
    func fetchOptions() -> [DashboardDisplayModel]  {
        var optionList = [DashboardDisplayModel]()
        optionList.append(getSiginOption())
        let options = (customer.workflow.map { $0.mapToDisplay() })
        optionList += options
        
        let list = updateVehicleCheckListOption(optionList: optionList).sorted(by: { $0.id < $1.id })
        return updateJobConfirmOption(optionList: list)
    }
    
    private func getSiginOption() -> DashboardDisplayModel {
        if Constant.isLogin {
            return DashboardDisplayModel(id: 0,
                                         title: configuration.string.signOut,
                                         icon: configuration.images.signin ?? UIImage(),
                                         type: .login,
                                         backgroundColor: Colors.colorPrimaryDark,
                                         textColor: Colors.colorWhite)
        } else {
            return DashboardDisplayModel(id: 0,
                                         title: configuration.string.signin,
                                         icon: configuration.images.signin ?? UIImage(),
                                         type: .login,
                                         backgroundColor: Colors.colorWhite,
                                         textColor: Colors.colorPrimary)
        }
    }
    
    private func updateVehicleCheckListOption(optionList: [DashboardDisplayModel]) -> [DashboardDisplayModel] {
        return optionList.map { model in
            if Constant.isVehicalCheck, model.id == 1 {
                return DashboardDisplayModel(id: model.id,
                                             title: model.title,
                                             icon: model.icon,
                                             type: model.type,
                                             backgroundColor: Colors.colorWhite,
                                             textColor: Colors.colorPrimary)
            }
            
            return model
        }
    }
    
    private func updateJobConfirmOption(optionList: [DashboardDisplayModel]) -> [DashboardDisplayModel] {
        if fetchManager.fetchUpdatedJobs().count > 0 {
            return optionList.map { model in
                if model.id == 2 {
                    return DashboardDisplayModel(id: model.id,
                                                 title: model.title,
                                                 icon: model.icon,
                                                 type: model.type,
                                                 backgroundColor: Colors.colorWhite,
                                                 textColor: Colors.colorPrimary)
                }
                
                return model
            }
        } else {
            return optionList
        }
    }
    
    private func fetchJobsForUpdate() {
        jobList = fetchManager.fetchJobListForUpdateReadStatus()
        if jobList.isEmpty {
            updateJobListComplete = true
        }
    }
    
    func checkFetchButtonStatus() -> Bool  {
        if Constant.isLogin {
            if !customer.hasVehicalCheckList {
                if Constant.isVehicalSubmit {
                    return jobList.isEmpty
                }
            } else {
                return jobList.isEmpty
            }
        }
        return true
    }
    
    func signOutDriver() {
        LocalTempStorage.removeValue(for: UserDefaultKeys.user)
        LocalTempStorage.removeValue(for: UserDefaultKeys.checkVehicle)
        LocalTempStorage.removeValue(for: UserDefaultKeys.isVehicalSubmit)
    }
    
    func fetchJobList() {
        Task { @MainActor in
            do {
                try await configuration.jobConformUsecase.fetchJob(completion: { result in
                    switch result  {
                    case .success(let value):
                        if let jobs = value.data.jobs, jobs.count > 0 {
                            self.jobList = jobs                            
                            RealmManager.shared.addAndUpdateObjectsToRealm(realmList: jobs)
                        } else {
                            print("error")
                        }
                    case .failure(_):
                        print("error")
                    }
                    self.fetchJobsForUpdate()
                    self.canShowFetchButton = self.checkFetchButtonStatus()
                })
            } catch (let error) {
                print(error)
            }
        }
    }
    
    func updateJobStatus()  {
        Task { @MainActor in
            do {
                let ids = jobList.map { $0.id }
                guard ids.count > 0 else {
                    self.updateJobListComplete = true
                    return
                }
                let requestModel = JobStatusUpdate(ids: ids, status: 5, branchCode: "code")
                try await configuration.jobConformUsecase.updateJob(request: requestModel, completion: { result in
                    self.canShowFetchButton = true
                    switch result {
                    case .success(let res):
                        if res.status == "Success" {
                            self.fetchManager.updateJobStatus(jobs: self.jobList)
                        }
                    default:
                        print("error")
                    }
                    self.updateJobListComplete = true
                })
            }
        }
    }
}

struct DashboardDisplayModel {
    let id: Int
    let title: String
    let icon: UIImage
    let type: Dashboard.DashboardOption
    let backgroundColor: UIColor
    let textColor: UIColor
}

