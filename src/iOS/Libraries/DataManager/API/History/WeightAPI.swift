//
//  WeightAPI.swift
//  DataManager
//
//  Created by Artem Kufaev on 31.05.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//

import Foundation
import NetworkCore

public enum WeightAPI {
    case getCollection
    case save(amount: Double, weighedAt: Int)
    case update(id: String, amount: Double, weighedAt: Int)
    case delete(id: String)
}

extension WeightAPI: INetworkAPI {
    
    public var path: String {
        switch self {
        case .getCollection, .save:
            return "history/weight/"
        case .update(let id, _, _):
            return "history/weight/\(id)"
        case .delete(let id):
            return "history/weight/\(id)"
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
            
        case .save(let amount, let weighedAt):
            return .requestParameters(bodyParameters: [
                "amount": amount,
                "weighedAt": weighedAt],
                                      urlParameters: nil)
            
        case .update(_, let amount, let weighedAt):
            return .requestParameters(bodyParameters: [
                "amount": amount,
                "weighedAt": weighedAt],
                                  urlParameters: nil)
        }
    }
    
}
