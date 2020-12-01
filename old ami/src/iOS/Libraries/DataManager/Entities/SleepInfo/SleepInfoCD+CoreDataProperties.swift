//
//  SleepInfoCD+CoreDataProperties.swift
//  DataManager
//
//  Created by Artem Kufaev on 23.05.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//
//

import Foundation
import CoreData

extension SleepInfoCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SleepInfoCD> {
        return NSFetchRequest<SleepInfoCD>(entityName: "SleepInfoCD")
    }

    @NSManaged public var id: String?
    @NSManaged public var endAt: Date?
    @NSManaged public var riseAt: Date?

}
