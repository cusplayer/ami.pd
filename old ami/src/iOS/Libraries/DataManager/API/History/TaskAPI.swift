//
//  TaskAPI.swift
//  DataManager
//
//  Created by Artem Kufaev on 31.05.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//

import Foundation
import NetworkCore

public enum TaskAPI {
    case getCollection
    case save(title: String, notifyAt: Int, createdAt: Int)
    case update(id: String, title: String, notifyAt: Int, createdAt: Int)
    case delete(id: String)
}

extension TaskAPI: INetworkAPI {
    
    public var path: String {
        switch self {
        case .getCollection, .save:
            return "history/tasks/"
        case .update(let id, _, _, _):
            return "history/tasks/\(id)"
        case .delete(let id):
            return "history/tasks/\(id)"
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
            
        case .save(let title, let notifyAt, let createdAt):
            return .requestParameters(bodyParameters: [
                "title": title,
                "notifyAt": notifyAt,
                "createdAt": createdAt],
                                      urlParameters: nil)
            
        case .update(_, let title, let notifyAt, let createdAt):
            return .requestParameters(bodyParameters: [
                "title": title,
                "notifyAt": notifyAt,
                "createdAt": createdAt],
                                      urlParameters: nil)
        }
    }
    
}
