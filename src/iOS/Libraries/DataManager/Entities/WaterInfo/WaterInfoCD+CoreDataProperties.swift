//
//  WaterInfoCD+CoreDataProperties.swift
//  DataManager
//
//  Created by Artem Kufaev on 23.05.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//
//

import Foundation
import CoreData

extension WaterInfoCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WaterInfoCD> {
        return NSFetchRequest<WaterInfoCD>(entityName: "WaterInfoCD")
    }

    @NSManaged public var id: String?
    @NSManaged public var amount: Int32
    @NSManaged public var drinkedAt: Date?

}
