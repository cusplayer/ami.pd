//
//  WeightInfoCD+CoreDataProperties.swift
//  DataManager
//
//  Created by Artem Kufaev on 23.05.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//
//

import Foundation
import CoreData

extension WeightInfoCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WeightInfoCD> {
        return NSFetchRequest<WeightInfoCD>(entityName: "WeightInfoCD")
    }

    @NSManaged public var id: String?
    @NSManaged public var amount: Double
    @NSManaged public var weighedAt: Date?

}
