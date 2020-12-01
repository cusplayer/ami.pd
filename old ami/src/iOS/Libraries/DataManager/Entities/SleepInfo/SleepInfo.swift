//
//  SleepInfo.swift
//  DataManager
//
//  Created by Artem Kufaev on 23.05.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//

import Foundation
import Storage
import CoreData

public struct SleepInfo: Decodable {
    public let id: String
    public let endAt: Date
    public let riseAt: Date
                        
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case endAt, riseAt
    }
        
}

extension SleepInfo {
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(String.self, forKey: .id)
        var timeInterval = TimeInterval(try values.decode(Int.self, forKey: .endAt))
        endAt = Date(timeIntervalSince1970: timeInterval)
        timeInterval = TimeInterval(try values.decode(Int.self, forKey: .riseAt))
        riseAt = Date(timeIntervalSince1970: timeInterval)
    }
}

extension SleepInfo: ManagedObjectConvertible {
    public typealias ManagedObject = SleepInfoCD
    
    public func toManagedObject(in context: NSManagedObjectContext) -> ManagedObject? {
        guard let obj = SleepInfoCD.getOrCreateSingle(with: id, from: context) else { return nil }
        obj.id = id
        obj.endAt = endAt
        obj.riseAt = riseAt
        return obj
    }
}
