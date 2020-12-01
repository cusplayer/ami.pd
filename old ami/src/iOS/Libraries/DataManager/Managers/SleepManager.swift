//
//  SleepManager.swift
//  DataManager
//
//  Created by Artem Kufaev on 31.05.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//

import Foundation
import NetworkCore
import Storage

public class SleepManager: IDataManager<SleepAPI, SleepInfo> {
    
    public func get(completion: @escaping (NetworkResultWithModel<[SleepInfo]>) -> Void) {
        storage.readAll {
            completion(.success($0))
            self.storage.delete($0)
        }
        let api: SleepAPI = .getCollection
        provider.load(api) { (result: NetworkResultWithModel<[SleepInfo]>) in
            switch result {
            case .success(let sleepHistory):
                self.storage.write(sleepHistory)
            default: break
            }
            completion(result)
        }
    }
    
    public func save(endAt: Date,
                     riseAt: Date,
                     completion: @escaping (NetworkResultWithModel<SleepInfo>) -> Void) {
        let api: SleepAPI = .save(endAt: Int(endAt.timeIntervalSince1970),
                                  riseAt: Int(riseAt.timeIntervalSince1970))
        provider.load(api) { (result: NetworkResultWithModel<SleepInfo>) in
            switch result {
            case .success(let sleepInfo):
                self.storage.write(sleepInfo)
            default: break
            }
            completion(result)
        }
    }
    
    public func update(id: String,
                       endAt: Date,
                       riseAt: Date,
                       completion: @escaping (NetworkResultWithModel<SleepInfo>) -> Void) {
        let api: SleepAPI = .update(id: id,
                                    endAt: Int(endAt.timeIntervalSince1970),
                                    riseAt: Int(riseAt.timeIntervalSince1970))
        provider.load(api) { (result: NetworkResultWithModel<SleepInfo>) in
            switch result {
            case .success(let sleepInfo):
                self.storage.write(sleepInfo)
            default: break
            }
            completion(result)
        }
    }
    
    public func delete(id: String, completion: @escaping (NetworkResult) -> Void) {
        let api: SleepAPI = .delete(id: id)
        storage.read(identifier: id) { (sleepInfo) in
            if let sleepInfo = sleepInfo {
                self.storage.delete(sleepInfo)
            }
        }
        provider.load(api) { (result) in
            completion(result)
        }
    }
    
}
