//
//  URLRequest+Extension.swift
//  CTS POD
//
//  Created by Aman Prajapati on 8/12/23.
//

import Foundation

extension URLRequest {

    init(endpoint: EndpointConfiguration, requestBodyEncoder: RequestBodyEncoder = JSONEncoder() ) throws {
        
        var urlComponent = URLComponents(string: endpoint.path)
        
        if let queryParam = endpoint.queryParam {
            if urlComponent != nil {
                urlComponent!.queryItems =  queryParam
            } else {
                throw NetworkError.custom("Invalid URL")
            }
        }
        
        guard let url = urlComponent?.url else {
            throw NetworkError.custom("Invalid URL")
        }
        self.init(url: url)
        
        httpMethod = endpoint.method.rawValue
        
        if let body = endpoint.body {
            httpBody = try JSONEncoder().encode(body)
            setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
    }
}

public protocol RequestBodyEncoder {
    func encode<T>(_ value: T) throws -> Data where T: Encodable
}

extension JSONEncoder: RequestBodyEncoder {}