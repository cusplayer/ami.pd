//
//  WeightInfo.swift
//  DataManager
//
//  Created by Artem Kufaev on 23.05.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//

import Foundation
import Storage
import CoreData

public struct WeightInfo: Decodable {
    public let id: String
    public let amount: Double
    public let weighedAt: Date
        
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case amount, weighedAt
    }
        
}

extension WeightInfo {
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(String.self, forKey: .id)
        amount = try values.decode(Double.self, forKey: .amount)
        let timeInterval = TimeInterval(try values.decode(Int.self, forKey: .weighedAt))
        weighedAt = Date(timeIntervalSince1970: timeInterval)
    }
}

extension WeightInfo: ManagedObjectConvertible {
    public typealias ManagedObject = WeightInfoCD
    
    public func toManagedObject(in context: NSManagedObjectContext) -> ManagedObject? {
        guard let obj = WeightInfoCD.getOrCreateSingle(with: id, from: context) else { return nil }
        obj.id = id
        obj.amount = amount
        obj.weighedAt = weighedAt
        return obj
    }
}
