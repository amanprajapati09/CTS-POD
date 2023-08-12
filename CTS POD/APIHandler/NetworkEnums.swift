//
//  NetworkEnums.swift
//  NetworkLayer
//  WWL

import Foundation
/**
 Enum for HTTP Request type
 */
enum RequestMethods: String {
    case POST
    case PUT
    case GET
    case DELETE
    case PATCH
}

/**
 Enum for request response error
 */

enum NetworkError<CustomError>:Error {
    case NoInternet
    case badReqeuest
    case invalidParams
    case authentication
    case outdated
    case invalidURL
    case invalidRequestParams
    case UnAuthorised
    case custom(CustomError)
    case cancelled
    
    var isUnAuthorized : Bool {
        switch self {
            case .UnAuthorised:
                return true
            default:
                return false
        }
    }
}

struct ErrorResponse: Codable {
    var errorCode:String?
    var errorMessageLocalizationKey:String?
    var errorMessage:String
}

struct CustomError<E: Codable>: Error, Codable {
    var error: E
}
/**
 Enum to map request response into success and failuer
 */

enum Result<T, E> {
    case success(T)
    case failure(E)
}

extension Result {
    init(value: T?, or error: E) {
        guard let value = value else {
            self = .failure(error)
            return
        }
        self = .success(value)
    }
    
    var value: T? {
        guard case let .success(value) = self else { return nil }
        return value
    }
    
    var error: E? {
        guard case let .failure(error) = self else { return nil }
        return error
    }
}

struct MultipartData {
    var fieldName:String?
    var fieldValue:String?
    
    var dFeidlName:String! {
        if let value = fieldName {
            return value
        } else {
            return ""
        }
    }
    
    var dFeidlValueName:String! {
        if let value = fieldValue {
            return value
        } else {
            return ""
        }
    }
}

enum ResponseStatus {
    case success
    case failure
}

struct CommonError: Codable {
    let title:String
    let message:String
}

enum APIError: Error {
    case dataParshingError
    case invalidURL
}

extension NetworkError : LocalizedError {

    public var errorDescription: String? {
        switch self {
            case .custom(let error):
                return NSLocalizedString(error as! String, comment: "")
            case .authentication:
                return NSLocalizedString("strNotAutorized", comment: "")
            case .badReqeuest:
                return NSLocalizedString("strBadRequest", comment: "")
            case .invalidParams:
                return NSLocalizedString("\("strItsTechnicalError") \n \("strContactSupportTeam")", comment: "")
            case .invalidRequestParams:
                return NSLocalizedString("strInvalidRequestParameters", comment: "")
            case .invalidURL:
                return NSLocalizedString("strInvalidURL", comment: "")
            case .NoInternet:
                return NSLocalizedString("strNoInternetConnection", comment: "")
            case .outdated:
                return NSLocalizedString("strOutdated", comment: "")
            case .UnAuthorised:
                return NSLocalizedString("strUnAuthorized", comment: "")
            case .cancelled:
                return NSLocalizedString("strCancelled", comment: "")
        }
    }
}
