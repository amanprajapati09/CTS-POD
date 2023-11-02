
import Foundation

class LocalDataBaseWraper {
    private let realmManager = RealmManager.shared
    
    func fetchJobListForUpdateReadStatus() -> [Job] {
        let jobs = realmManager.fetchList(type: Job.self)?.filter({
            $0.status == 4
        }) ?? []
        return jobs
    }
    
    func updateJobStatus(jobs: [Job]) {
        try! realmManager.realm.write {
            _ = jobs.map { job in
                job.status = 5
            }
        }
    }
    
    func fetchUpdatedJobs() -> [Job] {
        let jobs = realmManager.fetchList(type: Job.self)?.filter({
            $0.status == 5 && $0.jobStatus == nil
        }) ?? []
        return jobs
    }
    
    func fetchJobsForDeliveryList() -> [Job] {
        let jobs = realmManager.fetchList(type: Job.self)?.filter({
            $0.status == 5 && $0.jobStatus == StatusString.jobConfirm.rawValue
        }) ?? []
        return jobs
    }
    
    func updateEtaStatus(job: Job, status: ETAString) {
        try! realmManager.realm.write {
            job.ETAStatus = status.rawValue
        }
    }
}

