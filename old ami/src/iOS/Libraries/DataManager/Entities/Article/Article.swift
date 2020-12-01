//
//  Article.swift
//  DataManager
//
//  Created by Artem Kufaev on 23.05.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//

import Foundation
import CoreData
import Storage

public struct Article: Decodable {
    public let id: String
    public let title: String
    public let content: String
    public let createdAt: Date
                    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case title, content, createdAt
    }
        
}

extension Article {
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(String.self, forKey: .id)
        title = try values.decode(String.self, forKey: .title)
        content = try values.decode(String.self, forKey: .content)
        let timeInterval = TimeInterval(try values.decode(Int.self, forKey: .createdAt))
        createdAt = Date(timeIntervalSince1970: timeInterval)
    }
}

extension Article: ManagedObjectConvertible {
    public typealias ManagedObject = ArticleCD
    
    public func toManagedObject(in context: NSManagedObjectContext) -> ManagedObject? {
        guard let obj = ArticleCD.getOrCreateSingle(with: id, from: context) else { return nil }
        obj.id = id
        obj.title = title
        obj.content = content
        obj.createdAt = createdAt
        return obj
    }
}
