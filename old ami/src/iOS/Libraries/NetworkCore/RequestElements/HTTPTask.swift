//
//  HTTPTask.swift
//  NetworkCore
//
//  Created by Artem Kufaev on 09.05.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//

public typealias Parameters = [String: Any]

public enum HTTPTask {
    case request
    
    case requestParameters(
        bodyParameters: Parameters?,
        urlParameters: Parameters?)
}
