//
//  APIHandler.swift
//  CTS POD
//
//  Created by Aman Prajapati on 8/6/23.
//

import Foundation
import UIKit

protocol WebClient {
    func load<T: Decodable, E: Error>(urlRequest: URLRequest, completion: @escaping (Result<T, E>)->()) -> URLSessionDataTask?
}

struct APIClient {
    static let sharedObject = APIClient()
    /*
     This method is for actual Error handling come from api
     */
    fileprivate func handleNetworkResponse(_ response: HTTPURLResponse) -> ResponseStatus {
        //* Comment this code becaus API does not implement status code*/
        switch response.statusCode {
        case 200...299: return .success
        case 401,403: return .failure
        case 404...500: return .failure
        case 501...599: return .failure
        case -999: return .failure
        default: return .failure
        }
    }
}

extension APIClient: WebClient  {
    func load<T: Decodable, E: Error>(urlRequest: URLRequest, completion: @escaping (Result<T, E>) -> ()) -> URLSessionDataTask? {
        let session = URLSession.shared
        return executeTask(session: session, request: urlRequest, completion: completion)
    }
    
    
    private func executeTask<T: Decodable, E: Error>(session:URLSession, request: URLRequest, completion: @escaping (Result<T, E>)->()) -> URLSessionDataTask? {
        do {
            let task = session.dataTask(with: request) { data, response, error in
                DispatchQueue.main.async {
                    do {
                        guard let response = response else { return }
                        switch self.handleNetworkResponse(response as! HTTPURLResponse) {
                        case .success:
                            let result = try JSONDecoder().decode(T.self, from: data!)
                            completion(.success(result))
                        case .failure:
                            if let error = error {
                                completion(.failure(error as! E))
                            }
                        }
                    } catch (let err) {
                        completion(.failure(err as! E))
                    }
                    
                }
            }
            return task
        }
    }
}
