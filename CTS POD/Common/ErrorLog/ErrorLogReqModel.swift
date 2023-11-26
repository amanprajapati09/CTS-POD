//
//  ErrorLogReqModel.swift
//  CTS POD
//
//  Created by Aman Prajapati on 25/11/23.
//

import Foundation

struct ErrorLogReqModel: Codable {
    let customerID, userID, deviceInfo, errorTrace: String
    let apiErrorResponse, otherDetails, errorTimeStamp, createdTimeStamp: String
}

