//
//  CoreDataManager.swift
//  BookStore
//
//  Created by Siwon Kim on 2022/09/28.
//

import SwiftUI
import CoreData
import Combine

class CoreDataManager {
    private let container: NSPersistentContainer
    
    init() {
        self.container = NSPersistentContainer(name: "SearchResultsContainer")
        self.container.loadPersistentStores { description, error in
            if let error = error {
                print("Error Loading Core Data. \(error.localizedDescription)")
            } else {
                print("Successfully loaded Core Data")
            }
        }
    }

    func fetch(request: NSFetchRequest<BookEntity>) -> AnyPublisher<[BookEntity], Error> {
        return Deferred { [weak self] () -> Future<[BookEntity], Error> in
            guard let self = self else {
                return Future<[BookEntity], Error> { promise in
                    promise(.failure(URLSessionError.invaildData))
                }
            }
            
            guard let entities = try? self.container.viewContext.fetch(request),
                  entities.count != 0 else {
                return Future<[BookEntity], Error> { promise in
                    promise(.failure(URLSessionError.invaildData))
                }
            }
            return Future { promise in
                promise(.success(entities))
                print("core data cache, page:", entities[0].page!)
            }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()

    }
    
    func add(bookList: BookList, keyword: String) {
        bookList.books.forEach { book in
            var order: Int = 1
            let bookEntity = BookEntity(context: container.viewContext)
            bookEntity.id = book.id
            bookEntity.title = book.title
            bookEntity.subtitle = book.subtitle
            bookEntity.isbn13 = book.isbn13
            bookEntity.price = book.price
            bookEntity.imageUrl = book.image
            bookEntity.url = book.url
            bookEntity.timeStamp = Date()
            bookEntity.searchResultOrder = Int64(order)
            bookEntity.searchKeyword = keyword
            bookEntity.page = bookList.currentPage
            
            order += 1
            save()
        }
    }
    
    func save() {
        do {
            try container.viewContext.save()
        } catch {
            print("error saving core data", error.localizedDescription)
        }
    }
    
    func delete(entity: BookEntity) {
        container.viewContext.delete(entity)
    }
}
