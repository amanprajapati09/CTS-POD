//
//  SharedObject.swift
//  CTS POD
//
//  Created by Aman Prajapati on 8/20/23.
//

import Foundation

final class SharedObject {
    public static let shared = SharedObject()
    private init() {}
    
    var customer: Customer?
}
