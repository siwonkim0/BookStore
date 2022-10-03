//
//  URLSessionManager.swift
//  BookStore
//
//  Created by Siwon Kim on 2022/09/19.
//

import Foundation
import Combine

protocol URLSessionManagerType {
    func performDataTask<T: NetworkRequest>(urlRequest: T) -> AnyPublisher<T.ResponseType, Error>
}

final class URLSessionManager: URLSessionManagerType {
    private let urlSession: URLSessionProtocol

    init(urlSession: URLSessionProtocol = URLSession.shared) {
        self.urlSession = urlSession
    }

    // MARK: - Networking
    func performDataTask<T: NetworkRequest>(urlRequest: T) -> AnyPublisher<T.ResponseType, Error> {
        guard let request = urlRequest.urlRequest else {
            return Fail(error: URLSessionError.invalidRequest).eraseToAnyPublisher()
        }
        return urlSession.dataTaskPublisher(for: request)
            .mapError { (networkError : URLError) -> Error  in
                return URLSessionError.networkUnavailable
            }
            .tryMap { data, response -> T.ResponseType in
                guard let httpResponse = response as? HTTPURLResponse,
                      (200..<300).contains(httpResponse.statusCode) else {
                    throw URLSessionError.responseFailed
                }
                let decoder = JSONDecoder()
                
                do {
                    return try decoder.decode(T.ResponseType.self, from: data)
                } catch {
                    throw URLSessionError.decodingFailed
                }
            }
            .eraseToAnyPublisher()
    }
    
}
