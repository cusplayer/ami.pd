//
//  TaskInfoCD+CoreDataProperties.swift
//  DataManager
//
//  Created by Artem Kufaev on 23.05.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//
//

import Foundation
import CoreData

extension TaskInfoCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TaskInfoCD> {
        return NSFetchRequest<TaskInfoCD>(entityName: "TaskInfoCD")
    }

    @NSManaged public var id: String?
    @NSManaged public var title: String?
    @NSManaged public var notifyAt: Date?
    @NSManaged public var createdAt: Date?

}
