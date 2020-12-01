//
//  WaterInfoCD+CoreDataClass.swift
//  DataManager
//
//  Created by Artem Kufaev on 23.05.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//
//

import Foundation
import CoreData
import Storage

@objc(WaterInfoCD)
public class WaterInfoCD: NSManagedObject {
    public class func getOrCreateSingle(with id: String, from context: NSManagedObjectContext) -> WaterInfoCD? {
        let entityName = String(describing: Self.self)
        let request = NSFetchRequest<WaterInfoCD>(entityName: entityName)
        request.predicate = NSPredicate(format: "id == %@", id)
        guard let result = try? context.fetch(request) else { return nil }
        return result.first ?? WaterInfoCD(context: context)
    }
}

extension WaterInfoCD: ManagedObjectProtocol {
    public typealias Entity = WaterInfo
    
    public func toEntity() -> Entity? {
        guard let id = id,
            let drinkedAt = drinkedAt else { return nil }
        return WaterInfo(id: id, amount: Int(amount), drinkedAt: drinkedAt)
    }
}
