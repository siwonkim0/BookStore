//
//  SearchRepository.swift
//  BookStore
//
//  Created by Siwon Kim on 2022/09/19.
//

import Foundation
import Combine

final class SearchRepository: SearchRepositoryType {
    private let urlSessionManager: URLSessionManager
    
    init(urlSessionManager: URLSessionManager) {
        self.urlSessionManager = urlSessionManager
    }
    
    func getBookList(with keyword: String, page: String) -> AnyPublisher<BookListDTO, Error> {
        let request = SearchRequest(urlPath: keyword, page: page)
        return urlSessionManager.performDataTask(urlRequest: request)
    }
}
