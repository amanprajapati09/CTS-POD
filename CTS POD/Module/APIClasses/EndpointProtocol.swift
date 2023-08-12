//
//  EndpointProtocol.swift
//  CTS POD
//
//  Created by Aman Prajapati on 8/12/23.
//

import Foundation

protocol EndpointConfiguration {
    var path: String { get }
    var method: RequestMethods { get }
    var body: Encodable? { get }
    var queryParam: [URLQueryItem]? { get }
}
