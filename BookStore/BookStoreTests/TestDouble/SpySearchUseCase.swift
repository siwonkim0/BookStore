//
//  SpySearchUseCase.swift
//  BookStoreTests
//
//  Created by Siwon Kim on 2022/09/22.
//

import XCTest
import Combine

@testable import BookStore

class SpySearchUseCase: SearchUseCaseType {
    private var getBookListCallCount: Int = 0
    var result: Result<BookList, Error>
    
    init(result: Result<BookList, Error>) {
        self.result = result
    }
    
    func getBookList(with keyword: String, page: Int) -> AnyPublisher<BookList, Error> {
        getBookListCallCount += 1
        
        return result.publisher
            .eraseToAnyPublisher()
    }
    
    func verifygetBookList(callCount: Int) {
        XCTAssertEqual(getBookListCallCount, callCount)
    }
    
    
}
