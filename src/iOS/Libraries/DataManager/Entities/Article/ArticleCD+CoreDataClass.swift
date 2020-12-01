//
//  ArticleCD+CoreDataClass.swift
//  DataManager
//
//  Created by Artem Kufaev on 23.05.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//
//

import Foundation
import CoreData
import Storage

@objc(ArticleCD)
public class ArticleCD: NSManagedObject {
    public class func getOrCreateSingle(with id: String, from context: NSManagedObjectContext) -> ArticleCD? {
        let entityName = String(describing: Self.self)
        let request = NSFetchRequest<ArticleCD>(entityName: entityName)
        request.predicate = NSPredicate(format: "id == %@", id)
        guard let result = try? context.fetch(request) else { return nil }
        return result.first ?? ArticleCD(context: context)
    }
}

extension ArticleCD: ManagedObjectProtocol {
    public typealias Entity = Article

    public func toEntity() -> ArticleCD.Entity? {
        guard let id = id,
            let title = title,
            let content = content,
            let createdAt = createdAt else { return nil }
        return Article(id: id, title: title, content: content, createdAt: createdAt)
    }
}
