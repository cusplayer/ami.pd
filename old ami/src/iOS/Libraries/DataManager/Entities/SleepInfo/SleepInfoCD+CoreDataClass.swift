//
//  SleepInfoCD+CoreDataClass.swift
//  DataManager
//
//  Created by Artem Kufaev on 23.05.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//
//

import Foundation
import CoreData
import Storage

@objc(SleepInfoCD)
public class SleepInfoCD: NSManagedObject {
    public class func getOrCreateSingle(with id: String, from context: NSManagedObjectContext) -> SleepInfoCD? {
        let entityName = String(describing: Self.self)
        let request = NSFetchRequest<SleepInfoCD>(entityName: entityName)
        request.predicate = NSPredicate(format: "id == %@", id)
        guard let result = try? context.fetch(request) else { return nil }
        return result.first ?? SleepInfoCD(context: context)
    }
}

extension SleepInfoCD: ManagedObjectProtocol {
    public typealias Entity = SleepInfo
    
    public func toEntity() -> Entity? {
        guard let id = id,
            let endAt = endAt,
            let riseAt = riseAt else { return nil }
        return SleepInfo(id: id, endAt: endAt, riseAt: riseAt)
    }
}
