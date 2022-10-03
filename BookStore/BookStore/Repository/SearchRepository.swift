//
//  SearchRepository.swift
//  BookStore
//
//  Created by Siwon Kim on 2022/09/19.
//

import Foundation
import Combine
import CoreData

protocol SearchRepositoryType {
    func getResult(with keyword: String, page: String) -> AnyPublisher<BookList, Error>
}

final class SearchRepository: SearchRepositoryType {
    private let urlSessionManager: URLSessionManagerType
    private let coreDataManager: CoreDataManagerType
    
    init(urlSessionManager: URLSessionManagerType, coreDataManager: CoreDataManagerType) {
        self.urlSessionManager = urlSessionManager
        self.coreDataManager = coreDataManager
    }
    
    func getResult(with keyword: String, page: String) -> AnyPublisher<BookList, Error> {
        return getCachedResult(with: keyword, page: page)
            .catch { error in
                self.getNewResult(with: keyword, page: page)
            }
            .eraseToAnyPublisher()
    }
    
    private func getNewResult(with keyword: String, page: String) -> AnyPublisher<BookList, Error> {
        let request = SearchRequest(urlPath: keyword + "/" + page)
        return urlSessionManager.performDataTask(urlRequest: request)
            .tryMap { bookListDTO -> BookListDTO in
                if bookListDTO.total == "0" {
                    throw URLSessionError.invalidData
                } else {
                    return bookListDTO
                }
            }
            .eraseToAnyPublisher()
            .receive(on: DispatchQueue.main)
            .tryMap {
                print("urlsession, page:", page)
                guard let bookList = $0.toDomain() else {
                    throw URLSessionError.invalidData
                }
                do {
                    try self.coreDataManager.add(bookList: bookList, keyword: keyword)
                } catch {
                    throw CoreDataError.failedToAdd
                }
                return bookList
            }
            .eraseToAnyPublisher()
    }
    
    private func getCachedResult(with keyword: String, page: String) -> AnyPublisher<BookList, Error>  {
        let request = NSFetchRequest<BookEntity>(entityName: "BookEntity")
        let keywordPredicate = NSPredicate(format: "searchKeyword = %@", keyword)
        let pagePredicate = NSPredicate(format: "page = %@", page)
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [keywordPredicate, pagePredicate])

        return coreDataManager.fetch(request: request)
            .map { items in
                BookList(
                    currentPage: items[0].page ?? "",
                    totalPage: items[0].totalPage ?? "",
                    books: items.map { $0.toDomain() }
                )
            }
            .eraseToAnyPublisher()
    }

}
