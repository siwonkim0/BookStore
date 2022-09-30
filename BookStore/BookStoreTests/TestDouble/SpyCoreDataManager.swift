//
//  SpyCoreDataManager.swift
//  BookStoreTests
//
//  Created by Siwon Kim on 2022/09/30.
//

import XCTest
import Combine
import CoreData

@testable import BookStore

final class SpyCoreDataManager: CoreDataManagerType {
    private var fetchCallCount: Int = 0
    private var addCallCount: Int = 0
    var result: Result<[BookEntity], Error>
    
    init(result: Result<[BookEntity], Error>) {
        self.result = result
    }
    
    func fetch(request: NSFetchRequest<BookEntity>) -> AnyPublisher<[BookEntity], Error> {
        fetchCallCount += 1
        return result.publisher
            .eraseToAnyPublisher()
    }
    
    func add(bookList: BookList, keyword: String) {
        addCallCount += 1
    }
    
    func delete(entity: BookEntity) {
        //..
    }
    
    func verifyFetch(callCount: Int) {
        XCTAssertEqual(fetchCallCount, callCount)
    }
    
    func verifyAdd(callCount: Int) {
        XCTAssertEqual(addCallCount, callCount)
    }
    
}
