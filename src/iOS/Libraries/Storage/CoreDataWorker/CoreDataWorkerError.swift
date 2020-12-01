//
//  CoreDataWorkerError.swift
//  Storage
//
//  Created by Artem Kufaev on 03.05.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//

import Foundation

public enum CoreDataWorkerError: Error, LocalizedError {
    case cannotFetch(Error)
    case cannotSave(Error)
    case cannotConvertion
    case cannotDelete(Error)

    public var localizedDescription: String {
        switch self {
        case .cannotFetch(let error):
            return "Cannot fetch error: \(error))"
        case .cannotConvertion:
            return "Cannot convert object"
        case .cannotDelete(let error):
            return "Cannot delete object error: \(error)"
        case .cannotSave(let error):
            return "Cannot save object error: \(error)"
        }
    }
}
