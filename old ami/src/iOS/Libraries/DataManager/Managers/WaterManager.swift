//
//  WaterManager.swift
//  DataManager
//
//  Created by Artem Kufaev on 31.05.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//

import Foundation
import NetworkCore
import Storage

public class WaterManager: IDataManager<WaterAPI, WaterInfo> {
    
    public func get(completion: @escaping (NetworkResultWithModel<[WaterInfo]>) -> Void) {
        storage.readAll {
            completion(.success($0))
            self.storage.delete($0)
        }
        let api: WaterAPI = .getCollection
        provider.load(api) { (result: NetworkResultWithModel<[WaterInfo]>) in
            switch result {
            case .success(let waterHistory):
                self.storage.write(waterHistory)
            default: break
            }
            completion(result)
        }
    }
    
    public func save(amount: Int,
                     drinkedAt: Date,
                     completion: @escaping (NetworkResultWithModel<WaterInfo>) -> Void) {
        let api: WaterAPI = .save(amount: amount,
                                  drinkedAt: Int(drinkedAt.timeIntervalSince1970))
        provider.load(api) { (result: NetworkResultWithModel<WaterInfo>) in
            switch result {
            case .success(let waterInfo):
                self.storage.write(waterInfo)
            default: break
            }
            completion(result)
        }
    }
    
    public func update(id: String,
                       amount: Int,
                       drinkedAt: Date,
                       completion: @escaping (NetworkResultWithModel<WaterInfo>) -> Void) {
        let api: WaterAPI = .update(id: id,
                                    amount: amount,
                                    drinkedAt: Int(drinkedAt.timeIntervalSince1970))
        provider.load(api) { (result: NetworkResultWithModel<WaterInfo>) in
            switch result {
            case .success(let waterInfo):
                self.storage.write(waterInfo)
            default: break
            }
            completion(result)
        }
    }
    
    public func delete(id: String,
                       completion: @escaping (NetworkResult) -> Void) {
        let api: WaterAPI = .delete(id: id)
        storage.read(identifier: id) { (waterInfo) in
            if let waterInfo = waterInfo {
                self.storage.delete(waterInfo)
            }
        }
        provider.load(api) { (result) in
            completion(result)
        }
    }
    
}
