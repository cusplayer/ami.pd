//
//  ArticleCD+CoreDataProperties.swift
//  DataManager
//
//  Created by Artem Kufaev on 23.05.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//
//

import Foundation
import CoreData

extension ArticleCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ArticleCD> {
        return NSFetchRequest<ArticleCD>(entityName: "ArticleCD")
    }

    @NSManaged public var id: String?
    @NSManaged public var title: String?
    @NSManaged public var content: String?
    @NSManaged public var createdAt: Date?

}
