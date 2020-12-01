//
//  WeightInfoCD+CoreDataClass.swift
//  DataManager
//
//  Created by Artem Kufaev on 23.05.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//
//

import Foundation
import CoreData
import Storage

@objc(WeightInfoCD)
public class WeightInfoCD: NSManagedObject {
    public class func getOrCreateSingle(with id: String, from context: NSManagedObjectContext) -> WeightInfoCD? {
        let entityName = String(describing: Self.self)
        let request = NSFetchRequest<WeightInfoCD>(entityName: entityName)
        request.predicate = NSPredicate(format: "id == %@", id)
        guard let result = try? context.fetch(request) else { return nil }
        return result.first ?? WeightInfoCD(context: context)
    }
}

extension WeightInfoCD: ManagedObjectProtocol {
    public typealias Entity = WeightInfo
    
    public func toEntity() -> Entity? {
        guard let id = id,
            let weighedAt = weighedAt else { return nil }
        return WeightInfo(id: id, amount: amount, weighedAt: weighedAt)
    }
}
