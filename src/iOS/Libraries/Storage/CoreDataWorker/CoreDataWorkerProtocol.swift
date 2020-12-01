//
//  CoreDataWorkerProtocol.swift
//  Storage
//
//  Created by Artem Kufaev on 03.05.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//

import CoreData
 
public protocol CoreDataWorkerProtocol {
    func get<Entity: ManagedObjectConvertible>
        (with predicate: NSPredicate?,
         sortDescriptors: [NSSortDescriptor]?,
         fetchLimit: Int?,
         completion: @escaping (Result<[Entity], CoreDataWorkerError>) -> Void)
}
