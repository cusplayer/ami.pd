//
//  UserCD+CoreDataClass.swift
//  DataManager
//
//  Created by Artem Kufaev on 23.05.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//
//

import Foundation
import CoreData
import Storage

@objc(UserCD)
public class UserCD: NSManagedObject {
    public class func getOrCreateSingle(with id: String, from context: NSManagedObjectContext) -> UserCD? {
        let entityName = String(describing: Self.self)
        let request = NSFetchRequest<UserCD>(entityName: entityName)
        request.predicate = NSPredicate(format: "id == %@", id)
        guard let result = try? context.fetch(request) else { return nil }
        return result.first ?? UserCD(context: context)
    }
}

extension UserCD: ManagedObjectProtocol {
    public typealias Entity = User
    
    public func toEntity() -> Entity? {
        guard let id = id,
            let email = email,
            let name = name,
            let surname = surname,
            let birthdate = birthdate else { return nil }
        return User(id: id,
                    email: email,
                    name: name,
                    surname: surname,
                    birthdate: birthdate,
                    height: height,
                    appleId: appleId,
                    vkId: Int(vkId))
    }
}
