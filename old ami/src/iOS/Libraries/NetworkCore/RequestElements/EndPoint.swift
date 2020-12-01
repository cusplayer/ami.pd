//
//  EndPoint.swift
//  NetworkCore
//
//  Created by Artem Kufaev on 09.05.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//

public typealias HTTPHeaders = [String: String]

public protocol EndPointType {
    var schema: NetworkSchema { get }
    var host: String { get }
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var task: HTTPTask { get }
    var headers: HTTPHeaders? { get }
}
