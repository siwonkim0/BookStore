//
//  SpySearchRepository.swift
//  BookStoreTests
//
//  Created by Siwon Kim on 2022/09/22.
//

import XCTest
import Combine

@testable import BookStore

class SpySearchRepository: SearchRepositoryType {
    private var getResultCallCount: Int = 0
    var result: Result<BookList, Error>
    
    init(result: Result<BookList, Error>) {
        self.result = result
    }
    
    func getResult(with keyword: String, page: String) -> AnyPublisher<BookList, Error> {
        getResultCallCount += 1
        
        return result.publisher
            .eraseToAnyPublisher()
    }
    
    func verifygetResult(callCount: Int) {
        XCTAssertEqual(getResultCallCount, callCount)
    }
    
    
}
