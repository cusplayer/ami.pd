//
//  TokenManager.swift
//  DataManager
//
//  Created by Artem Kufaev on 31.05.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//

import Foundation
import Keychain
import NetworkCore

public class TokenManager {
    
    private static let tokenKey = "access_token"
    
    public static var accessToken: String? {
        get {
            return Keychain.load(tokenKey)
        }
        set {
            if let token = newValue {
                _ = Keychain.save(token, forKey: tokenKey)
            } else {
                _ = Keychain.delete(tokenKey)
            }
        }
    }
    
    private let provider: Provider<TokenAPI>
    
    public init() {
        provider = Provider<TokenAPI>(session: URLSession.shared,
                                      errorParser: ErrorParser())
    }
    
    public func refresh(completion: @escaping (NetworkResultWithModel<AccessToken>) -> Void) {
        guard let token = TokenManager.accessToken else { fatalError() }
        let api: TokenAPI = .refresh(token)
        provider.load(api) { (response: NetworkResultWithModel<AccessToken>) in
            switch response {
            case .success(let token):
                TokenManager.accessToken = token.accessToken
            default: break
            }
            completion(response)
        }
        
    }
    
}
