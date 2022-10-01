//
//  BookDetailRepository.swift
//  BookStore
//
//  Created by Siwon Kim on 2022/10/01.
//

import Foundation
import Combine

final class BookDetailRepository {
    private let urlSessionManager: URLSessionManagerType
    
    init(urlSessionManager: URLSessionManagerType) {
        self.urlSessionManager = urlSessionManager
    }
    
    func getBookDetails(with isbn: String) -> AnyPublisher<BookDetail, Error> {
        let request = BookDetailRequest(urlPath: isbn)
        return urlSessionManager.performDataTask(urlRequest: request)
            .map { $0.toDomain() }
            .eraseToAnyPublisher()
    }
}
