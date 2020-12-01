//
//  ManagedObjectConvertible.swift
//  Storage
//
//  Created by Artem Kufaev on 03.05.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//

import CoreData

public protocol ManagedObjectProtocol: NSManagedObject {
    associatedtype Entity
    func toEntity() -> Entity?
}

public protocol ManagedObjectConvertible {
    associatedtype ManagedObject: ManagedObjectProtocol
    func toManagedObject(in context: NSManagedObjectContext) -> ManagedObject?
}
