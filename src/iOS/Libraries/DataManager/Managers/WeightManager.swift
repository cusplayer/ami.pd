//
//  WeightManager.swift
//  DataManager
//
//  Created by Artem Kufaev on 31.05.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//

import Foundation
import NetworkCore
import Storage

public class WeightManager: IDataManager<WeightAPI, WeightInfo> {
    
    public func get(completion: @escaping (NetworkResultWithModel<[WeightInfo]>) -> Void) {
        storage.readAll {
            completion(.success($0))
            self.storage.delete($0)
        }
        let api: WeightAPI = .getCollection
        provider.load(api) { (result: NetworkResultWithModel<[WeightInfo]>) in
            switch result {
            case .success(let weightHistory):
                self.storage.write(weightHistory)
            default: break
            }
            completion(result)
        }
    }
    
    public func save(amount: Double,
                     weighedAt: Date,
                     completion: @escaping (NetworkResultWithModel<WeightInfo>) -> Void) {
        let api: WeightAPI = .save(amount: amount,
                                   weighedAt: Int(weighedAt.timeIntervalSince1970))
        provider.load(api) { (result: NetworkResultWithModel<WeightInfo>) in
            switch result {
            case .success(let weightInfo):
                self.storage.write(weightInfo)
            default: break
            }
            completion(result)
        }
    }
    
    public func update(id: String,
                       amount: Double,
                       weighedAt: Date,
                       completion: @escaping (NetworkResultWithModel<WeightInfo>) -> Void) {
        let api: WeightAPI = .update(id: id,
                                     amount: amount,
                                     weighedAt: Int(weighedAt.timeIntervalSince1970))
        provider.load(api) { (result: NetworkResultWithModel<WeightInfo>) in
            switch result {
            case .success(let weightInfo):
                self.storage.write(weightInfo)
            default: break
            }
            completion(result)
        }
    }
    
    public func delete(id: String, completion: @escaping (NetworkResult) -> Void) {
        let api: WeightAPI = .delete(id: id)
        storage.read(identifier: id) { (weightInfo) in
            if let weightInfo = weightInfo {
                self.storage.delete(weightInfo)
            }
        }
        provider.load(api) { (result) in
            completion(result)
        }
    }
    
}
