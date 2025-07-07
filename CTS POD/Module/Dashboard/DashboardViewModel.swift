
import UIKit
import Combine

final class DashboardViewModel {
    let configuration: Dashboard.Configuration
    let customer: Customer
    let fetchManager = LocalDataBaseWraper()
    @Published var syncState: APIState<JobStatusUpdateResponse>?
    
    @Published var canShowFetchButton: Bool = true
    @Published var updateJobListComplete: Bool = true
    @Published var showAlert: String?
    
    private var jobList = [Job]()
    
    init(configuration: Dashboard.Configuration, customer: Customer) {
        self.configuration = configuration
        self.customer = customer
    }
    
    func checkAutoLogout() {
        if let date = UserDefaults.standard.value(forKey: UserDefaultKeys.lastLoginTime) as? Date {
            if !Date().isTheSameDay(date: date) {
                signOutDriver()
            }
        }
    }
    
    func fetchOptions() -> [DashboardDisplayModel]  {
        var optionList = [DashboardDisplayModel]()
        optionList.append(getSiginOption())
        let options = (customer.workflow.map { $0.mapToDisplay() })
        optionList += options
        
        let firstlist = updateVehicleCheckListOption(optionList: optionList).filter({ $0.id < 2 }).sorted(by: { $0.id < $1.id })
        let secondlist = updateVehicleCheckListOption(optionList: optionList).filter({ $0.id > 1 }).sorted(by: { $0.id > $1.id })
        let list = firstlist + secondlist
        let updatedJobList = updateJobConfirmOption(optionList: list)
        return updateDeliveryConfirmOption(optionList: updatedJobList)
    }
    
    private func getSiginOption() -> DashboardDisplayModel {
        if Constant.isLogin {
            return DashboardDisplayModel(id: 0,
                                         title: configuration.string.signOut,
                                         icon: configuration.images.signOut ?? UIImage(),
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
            if Constant.isLogin, model.id == 1, !Constant.canShowVehicalCheck {
                return DashboardDisplayModel(id: model.id,
                                             title: model.title,
                                             icon: configuration.images.vehicanCheckDone ?? UIImage(),
                                             type: model.type,
                                             backgroundColor: Colors.colorPrimaryDark,
                                             textColor: Colors.colorWhite)
            }
            if Constant.canShowVehicalCheck, model.id == 1 {
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
        if customer.hasVehicalCheckList == false, !Constant.isVehicalCheck {
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
        if customer.hasVehicalCheckList == false, !Constant.isVehicalCheck {
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
                if !Constant.isVehicalCheck {
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
        LocalTempStorage.removeValue(for: UserDefaultKeys.isVehicalSubmit)
        LocalTempStorage.removeValue(for: UserDefaultKeys.lastTimeStampUpdateLocation)
    }
    
    func fetchJobList(canStore: Bool) {
        Task { @MainActor in
            do {
                try await configuration.jobConformUsecase.fetchJob(completion: { result in
                    switch result  {
                    case .success(let value):
                        if let jobs = value.data.jobs, jobs.count > 0 {
                            self.jobList = jobs
                            if canStore {
                                RealmManager.shared.addAndUpdateObjectsToRealm(realmList: jobs)
                                self.fetchJobsForUpdate()
                                self.updateJobStatus()
                            } else {
                                self.canShowFetchButton = self.checkFetchButtonStatus()
                            }
                        } else {
                            ErrorLogManager.uploadErrorLog(apiName: "Job/JobList", error: value.message)
                            self.fetchJobsForUpdate()
                        }
                    case .failure(let error):
                        ErrorLogManager.uploadErrorLog(apiName: "Job/JobList", error: error.localizedDescription)
                    }
                })
            } catch (let error) {
                print(error)
            }
        }
    }
    
    func updateJobStatus()  {
        Task { @MainActor in
            do {
                updateJobListComplete = false
                let ids = jobList.map { $0.id }
                guard ids.count > 0 else {
                    self.updateJobListComplete = true
                    self.showAlert = "Error"
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
        let localList = LocalDataBaseWraper().fetchLocalSavedJob()
        manageAPICallingIndex(index: 0, localList: localList)
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
    
    private func manageAPICallingIndex(index: Int, localList: [JobSubmitRequest]) {
        self.syncState = .loading
        guard index < localList.count else {
            self.syncState = .loaded(JobStatusUpdateResponse(status: "Done", message: "Success"))
            return
        }
        let requestModel = localList[index]
        callAPI(request: requestModel) { isSuccess in
            if isSuccess {
                RealmManager.shared.delete(realmList: localList[index])
                self.manageAPICallingIndex(index: (index + 1), localList: localList)
            } else {
                self.syncState = .error("Somthing went wrong! \nPlease try again!")
            }
        }
    }
    
    private func callAPI(request: JobSubmitRequest, complition: @escaping ((_ isSuccess: Bool)->Void)) {
        Task { @MainActor in
            do {
                try await configuration.jobSubmitUsecase.updateJobStatus(request: request) { result in
                    switch result {
                    case .success(let value):
                        if value.status == "Success" {
                            complition(true)
                        } else {
                            complition(false)
                            ErrorLogManager.uploadErrorLog(apiName: "Job/AddOrUpdateJobDocument", error: value.message)
                        }
                    case .failure(let error):
                        complition(false)
                        ErrorLogManager.uploadErrorLog(apiName: "Job/AddOrUpdateJobDocument", error: error.localizedDescription)
                    }
                }
            } catch (let error) {
                print(error)
                complition(false)
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

