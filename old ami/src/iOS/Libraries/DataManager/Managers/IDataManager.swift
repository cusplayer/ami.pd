//
//  IDataManager.swift
//  DataManager
//
//  Created by Artem Kufaev on 23.05.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//

import Foundation
import NetworkCore
import Storage

public class IDataManager<NetworkAPI: INetworkAPI, Model: Decodable & ManagedObjectConvertible> {

    internal var provider: Provider<NetworkAPI>
    internal var storage: Storage<Model>
    
    public init() {
        let parser: AbstractErrorParser = ErrorParser()
        provider = Provider<NetworkAPI>(session: URLSession.shared,
                                     errorParser: parser)
        storage = Storage<Model>(modelName: "Storage", bundle: Bundle(for: Self.self))
    }

}
