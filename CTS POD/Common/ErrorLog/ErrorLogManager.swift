//
//  ErrorLogManager.swift
//  CTS POD
//
//  Created by Aman Prajapati on 25/11/23.
//

import Foundation

class ErrorLogManager {
    static func uploadErrorLog(apiName: String, error: String) {
        let user = LocalTempStorage.getValue(fromUserDefault: LoginDetails.self, key: UserDefaultKeys.user)        
        let request = ErrorLogReqModel(customerID: user?.id ?? "0",
                                       userID: user?.user.customerID ?? "0",
                                       deviceInfo: Constant.deviceID,
                                       errorTrace: apiName,
                                       apiErrorResponse: error,
                                       otherDetails: "",
                                       errorTimeStamp: Date().apiSupportedDate(),
                                       createdTimeStamp: Date().apiSupportedDate())
        let usecase = ErrorLogUsecase(client: ErrorLogClient())
        Task {
            do {
                try await usecase.logError(request: request) { result in
                    switch result {
                    case .success:
                        print("error log uploaded")
                    case .failure:
                        print("error in uploding errorlog")
                    }
                }
            } catch {
                print("error")
            }
        }
    }
}
