//
//  LocalDataBaseWraper.swift
//  CTS POD
//
//  Created by Aman Prajapati on 10/16/23.
//

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
            $0.status == 5
        }) ?? []
        return jobs
    }
}
