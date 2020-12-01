//
//  TaskManager.swift
//  DataManager
//
//  Created by Artem Kufaev on 31.05.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//

import Foundation
import NetworkCore
import Storage

public class TaskManager: IDataManager<TaskAPI, TaskInfo> {
    
    public func get(completion: @escaping (NetworkResultWithModel<[TaskInfo]>) -> Void) {
        storage.readAll {
            completion(.success($0))
            self.storage.delete($0)
        }
        let api: TaskAPI = .getCollection
        provider.load(api) { (result: NetworkResultWithModel<[TaskInfo]>) in
            switch result {
            case .success(let taskHistory):
                self.storage.write(taskHistory)
            default: break
            }
            completion(result)
        }
    }
    
    public func save(title: String,
                     notifyAt: Date,
                     createdAt: Date,
                     completion: @escaping (NetworkResultWithModel<TaskInfo>) -> Void) {
        let api: TaskAPI = .save(title: title,
                                 notifyAt: Int(notifyAt.timeIntervalSince1970),
                                 createdAt: Int(createdAt.timeIntervalSince1970))
        provider.load(api) { (result: NetworkResultWithModel<TaskInfo>) in
            switch result {
            case .success(let taskInfo):
                self.storage.write(taskInfo)
            default: break
            }
            completion(result)
        }
    }
    
    public func update(id: String,
                       title: String,
                       notifyAt: Date,
                       createdAt: Date,
                       completion: @escaping (NetworkResultWithModel<TaskInfo>) -> Void) {
        let api: TaskAPI = .update(id: id,
                                   title: title,
                                   notifyAt: Int(notifyAt.timeIntervalSince1970),
                                   createdAt: Int(createdAt.timeIntervalSince1970))
        provider.load(api) { (result: NetworkResultWithModel<TaskInfo>) in
            switch result {
            case .success(let taskInfo):
                self.storage.write(taskInfo)
            default: break
            }
            completion(result)
        }
    }
    
    public func delete(id: String,
                       completion: @escaping (NetworkResult) -> Void) {
        let api: TaskAPI = .delete(id: id)
        storage.read(identifier: id) { (taskInfo) in
            if let taskInfo = taskInfo {
                self.storage.delete(taskInfo)
            }
        }
        provider.load(api) { (result) in
            completion(result)
        }
    }
    
}
