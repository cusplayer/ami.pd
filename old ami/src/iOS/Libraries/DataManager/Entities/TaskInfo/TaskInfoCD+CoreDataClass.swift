//
//  TaskInfoCD+CoreDataClass.swift
//  DataManager
//
//  Created by Artem Kufaev on 23.05.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//
//

import Foundation
import CoreData
import Storage

@objc(TaskInfoCD)
public class TaskInfoCD: NSManagedObject {
    public class func getOrCreateSingle(with id: String, from context: NSManagedObjectContext) -> TaskInfoCD? {
        let entityName = String(describing: Self.self)
        let request = NSFetchRequest<TaskInfoCD>(entityName: entityName)
        request.predicate = NSPredicate(format: "id == %@", id)
        guard let result = try? context.fetch(request) else { return nil }
        return result.first ?? TaskInfoCD(context: context)
    }
}

extension TaskInfoCD: ManagedObjectProtocol {
    public typealias Entity = TaskInfo
    
    public func toEntity() -> Entity? {
        guard let id = id,
            let title = title,
            let notifyAt = notifyAt,
            let createdAt = createdAt else { return nil }
        return TaskInfo(id: id, title: title, notifyAt: notifyAt, createdAt: createdAt)
    }
}
