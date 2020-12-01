//
//  Provider.swift
//  NetworkCore
//
//  Created by Artem Kufaev on 10.05.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//

import Foundation

public enum NetworkResult {
    case success
    case failure(NetworkError)
}

public enum NetworkResultWithModel<T> {
    case success(T)
    case failure(NetworkError)
}

public protocol ProviderProtocol {
    associatedtype API

    typealias Completion = (_ response: NetworkResult) -> Void
    typealias CompletionWithResult<Model: Decodable> = (_ response: NetworkResultWithModel<Model>) -> Void

    func load<Model: Decodable>(_ apiMethod: API, completion: @escaping CompletionWithResult<Model>)
    func cancel()
}

open class Provider<API: INetworkAPI>: ProviderProtocol {

    public let session: URLSession
    private var task: URLSessionTask?
    private let errorParser: AbstractErrorParser?

    public init(session: URLSession = URLSession.shared, errorParser: AbstractErrorParser? = nil) {
        self.session = session
        self.errorParser = errorParser
    }
    
    open func load(_ apiMethod: API, completion: @escaping Completion) {
        guard let request = try? RequestBuilder.build(from: apiMethod) else {
            completion(.failure(.encodingFailed))
            return
        }
        task = session.dataTask(with: request) { (data, response, error) in
            if let error = self.errorParser?.parse(response: response, data: data, error: error) {
                completion(.failure(error))
                return
            }
            if let response = response as? HTTPURLResponse {
                guard 200..<300 ~= response.statusCode else {
                    completion(.failure(.serverFailed(code: response.statusCode, msg: nil)))
                    return
                }
            }
            if let error = error {
                completion(.failure(.error(error)))
                return
            }
            completion(.success)
        }
        self.task?.resume()
    }

    open func load<Model: Decodable>(_ apiMethod: API, completion: @escaping CompletionWithResult<Model>) {
        guard let request = try? RequestBuilder.build(from: apiMethod) else {
            completion(.failure(.encodingFailed))
            return
        }
        task = session.dataTask(with: request) { (data, response, error) in
            if let error = self.errorParser?.parse(response: response, data: data, error: error) {
                completion(.failure(error))
                return
            }
            if let error = error {
                completion(.failure(.error(error)))
                return
            }
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            do {
                let parsedData = try JSONDecoder().decode(Model.self, from: data)
                completion(.success(parsedData))
            } catch {
                completion(.failure(.decodingFailed(error, data)))
            }
        }
        self.task?.resume()
    }

    open func cancel() {
        self.task?.cancel()
    }

}
