//
//  SleepAPI.swift
//  DataManager
//
//  Created by Artem Kufaev on 31.05.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//

import Foundation
import NetworkCore

public enum SleepAPI {
    case getCollection
    case save(endAt: Int, riseAt: Int)
    case update(id: String, endAt: Int, riseAt: Int)
    case delete(id: String)
}

extension SleepAPI: INetworkAPI {
    
    public var path: String {
        switch self {
        case .getCollection, .save:
            return "history/sleep/"
        case .update(let id, _, _):
            return "history/sleep/\(id)"
        case .delete(let id):
            return "history/sleep/\(id)"
        }
    }
    
    public var headers: HTTPHeaders? {
        return ["Authorization": "Bearer " + accessToken]
    }
    
    public var httpMethod: HTTPMethod {
        switch self {
        case .getCollection: return .get
        case .save: return .post
        case .update: return .put
        case .delete: return .delete
        }
    }
    
    public var task: HTTPTask {
        switch self {
        case .getCollection: return .request
        case .delete: return .request
            
        case .save(let endAt, let riseAt):
            return .requestParameters(bodyParameters: [
                "endAt": endAt,
                "riseAt": riseAt],
                                      urlParameters: nil)
            
        case .update(_, let endAt, let riseAt):
            return .requestParameters(bodyParameters: [
                "endAt": endAt,
                "riseAt": riseAt],
                                      urlParameters: nil)
        }
    }
    
}
