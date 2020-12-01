//
//  ArticleAPI.swift
//  DataManager
//
//  Created by Artem Kufaev on 31.05.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//

import Foundation
import NetworkCore

public enum ArticleAPI {
    case getCollection
}

extension ArticleAPI: INetworkAPI {
    
    public var headers: HTTPHeaders? { return nil }
    public var path: String { return "articles/" }
    public var httpMethod: HTTPMethod { return .get }
    public var task: HTTPTask { return .request }
    
}
