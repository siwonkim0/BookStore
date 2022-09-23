//
//  StubSearchRepository.swift
//  BookStoreTests
//
//  Created by Siwon Kim on 2022/09/22.
//

import XCTest
import Combine

@testable import BookStore

final class StubSearchRepository: SearchRepositoryType {
    var isTotalResultsDividedIntoTen: Bool = false
    var result: Result<BookListDTO, Error>
    
    init(result: Result<BookListDTO, Error>) {
        self.result = result
    }
    
    func getBookList(with keyword: String, page: String) -> AnyPublisher<BookListDTO, Error> {
        return result.publisher
            .eraseToAnyPublisher()
    }
    
    
}
