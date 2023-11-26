
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
        let updatedJobList = updateDeliveryConfirmOption(optionList: list)
        return updateJobConfirmOption(optionList: updatedJobList)
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
        guard Constant.isLogin else { return optionList }
        if customer.hasVehicalCheckList == false, Constant.isVehicalSubmit {
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
            }
        }
        return optionList
    }
    
    private func updateDeliveryConfirmOption(optionList: [DashboardDisplayModel]) -> [DashboardDisplayModel] {
        guard Constant.isLogin else { return optionList }
        if customer.hasVehicalCheckList == false, Constant.isVehicalSubmit {
            if fetchManager.fetchJobsForDeliveryList().count > 0 {
                return optionList.map { model in
                    if model.id == 3 {
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
        }
        return optionList
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
    
    func checkForSyncData() -> Bool {
        if Constant.isLogin {
            if NetworkCheck.sharedInstance().currentStatus == .satisfied {
                if LocalDataBaseWraper().fetchLocalSavedJob().count > 0 {
                    return false
                } else {
                    return true
                }
            }
        }
        return true
    }
    
    func signOutDriver() {
        LocalTempStorage.removeValue(for: UserDefaultKeys.user)
        LocalTempStorage.removeValue(for: UserDefaultKeys.checkVehicle)
        LocalTempStorage.removeValue(for: UserDefaultKeys.isVehicalSubmit)
        LocalTempStorage.removeValue(for: UserDefaultKeys.lastTimeStampUpdateLocation)
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
                            ErrorLogManager.uploadErrorLog(apiName: "Job/JobList", error: value.message)
                        }
                    case .failure(let error):
                        ErrorLogManager.uploadErrorLog(apiName: "Job/JobList", error: error.localizedDescription)
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
                        } else {
                            ErrorLogManager.uploadErrorLog(apiName: "Job/ChangeJobStatus", error: res.message)
                        }
                    case .failure(let error):
                        ErrorLogManager.uploadErrorLog(apiName: "Job/ChangeJobStatus", error: error.localizedDescription)
                    }
                    self.updateJobListComplete = true
                })
            }
        }
    }
    
    func submitJobs()  {
        let jobs = LocalDataBaseWraper().fetchLocalSavedJob()        
        for job in jobs {
            Task {@MainActor in
                do {
                    try await configuration.jobSubmitUsecase.updateJobStatus(request: job) { result in
                        switch result {
                        case .success(let value):
                            if value.status == "Success" {
                                RealmManager.shared.delete(realmList: job)
                            } else {
                                ErrorLogManager.uploadErrorLog(apiName: "Job/AddOrUpdateJobDocument", error: value.message)
                            }
                        case .failure(let error):
                            ErrorLogManager.uploadErrorLog(apiName: "Job/AddOrUpdateJobDocument", error: error.localizedDescription)
                        }
                    }
                }
            }
        }
    }
    
    func fetchIncidentReport(completion: @escaping (_ result: [DynamicReportlist]?)->())  {
        Task {@MainActor in
            do {
                try await configuration.incidentReportUsecase.fetchDynamicReport(completion:  { result in
                    switch result {
                    case .success(let value):
                        if value.status == "Success" {
                            completion(result.value?.data.dynamicReportlist)
                        } else {
                            ErrorLogManager.uploadErrorLog(apiName: "DynamicIncidentReport/GetIncidenceReportDynamic", error: value.message)
                        }
                    case .failure(let error):
                        ErrorLogManager.uploadErrorLog(apiName: "DynamicIncidentReport/GetIncidenceReportDynamic", error: error.localizedDescription)
                    }
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

