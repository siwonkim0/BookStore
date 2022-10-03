//
//  BookDetailRepository.swift
//  BookStore
//
//  Created by Siwon Kim on 2022/10/01.
//

import Foundation
import Combine
import CoreData

final class BookDetailRepository {
    private let urlSessionManager: URLSessionManagerType
    private let coreDataManager: CoreDataManagerType
    
    init(urlSessionManager: URLSessionManagerType, coreDataManager: CoreDataManagerType) {
        self.urlSessionManager = urlSessionManager
        self.coreDataManager = coreDataManager
    }
    
    func getBookDetails(with isbn: String) -> AnyPublisher<BookDetail, Error> {
        let request = BookDetailRequest(urlPath: isbn)
        return urlSessionManager.performDataTask(urlRequest: request)
            .map { $0.toDomain() }
            .eraseToAnyPublisher()
    }
    
    func saveBookMemo(book: Book) -> AnyPublisher<Book, Error> {
        let request = NSFetchRequest<BookEntity>(entityName: "BookEntity")
        request.predicate = NSPredicate(format: "id = %@", book.id as CVarArg)

        return coreDataManager.fetch(request: request)
            .tryMap { items in
                guard let bookEntity = items.first else {
                    throw CoreDataError.invalidData
                }
                do {
                    bookEntity.memo = book.memo
                    try self.coreDataManager.update(entity: bookEntity)
                } catch {
                    throw CoreDataError.failedToUpdate
                }
                return book
            }
            .eraseToAnyPublisher()
        
    }
}
