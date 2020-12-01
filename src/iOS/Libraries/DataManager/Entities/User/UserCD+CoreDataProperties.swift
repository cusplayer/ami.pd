//
//  UserCD+CoreDataProperties.swift
//  DataManager
//
//  Created by Artem Kufaev on 23.05.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//
//

import Foundation
import CoreData

extension UserCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserCD> {
        return NSFetchRequest<UserCD>(entityName: "UserCD")
    }

    @NSManaged public var appleId: String?
    @NSManaged public var birthdate: Date?
    @NSManaged public var email: String?
    @NSManaged public var height: Double
    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var surname: String?
    @NSManaged public var vkId: Int32

}
