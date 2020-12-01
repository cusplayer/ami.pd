//
//  AbstractErrorParser.swift
//  NetworkCore
//
//  Created by Artem Kufaev on 31.05.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//

import Foundation

public protocol AbstractErrorParser {
    func parse(_ result: Error) -> NetworkError
    func parse(response: URLResponse?, data: Data?, error: Error?) -> NetworkError?
}
