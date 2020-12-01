//
//  WaterAPI.swift
//  DataManager
//
//  Created by Artem Kufaev on 31.05.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//

import Foundation
import NetworkCore

public enum WaterAPI {
    case getCollection
    case save(amount: Int, drinkedAt: Int)
    case update(id: String, amount: Int, drinkedAt: Int)
    case delete(id: String)
}

extension WaterAPI: INetworkAPI {
    
    public var path: String {
        switch self {
        case .getCollection, .save:
            return "history/water/"
        case .update(let id, _, _):
            return "history/water/\(id)"
        case .delete(let id):
            return "history/water/\(id)"
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
            
        case .save(let amount, let drinkedAt):
            return .requestParameters(bodyParameters: [
                "amount": amount,
                "drinkedAt": drinkedAt],
                                      urlParameters: nil)
            
        case .update(_, let amount, let drinkedAt):
            return .requestParameters(bodyParameters: [
                "amount": amount,
                "drinkedAt": drinkedAt],
                                      urlParameters: nil)
        }
    }
    
}
