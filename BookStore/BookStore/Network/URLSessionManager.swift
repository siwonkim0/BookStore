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
    private var urlSession: URLSessionProtocol

    init(urlSession: URLSessionProtocol = URLSession.shared) {
        self.urlSession = urlSession
    }

    // MARK: - Networking
    func performDataTask<T: NetworkRequest>(urlRequest: T) -> AnyPublisher<T.ResponseType, Error> {
        guard let request = urlRequest.urlRequest else {
            return Fail(error: URLSessionError.invalidRequest).eraseToAnyPublisher()
        }
        return urlSession.dataTaskPublisher(for: request)
            .tryMap { data, response in
                if let httpResponse = response as? HTTPURLResponse,
                   httpResponse.statusCode >= 300 {
                    throw URLSessionError.responseFailed(code: httpResponse.statusCode)
                }
                return data
            }
            .decode(type: T.ResponseType.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
}
