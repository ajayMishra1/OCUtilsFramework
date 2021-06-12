//
//  AlmofireEssential.swift
//  Laytrip
//
//  Created by AjaY.. on 29/06/20.
//  Copyright © 2020 AJAY MISHRA. All rights reserved.
//


import Alamofire

public protocol RequireType {
    var baseURL: String { get }
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var headers: HTTPHeaders? { get }
    var url: URL { get }
    var encoding: ParameterEncoding { get }
    var version: String { get }
    
}
