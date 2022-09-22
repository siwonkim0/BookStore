//
//  SpySearchUseCase.swift
//  BookStoreTests
//
//  Created by Siwon Kim on 2022/09/22.
//

import XCTest
@testable import BookStore

import Foundation
import Combine

class SpySearchUseCase: SearchUseCaseType {
    private var getBookListCallCount: Int = 0
    
    func getBookList(with keyword: String, page: Int) -> AnyPublisher<BookList, Error> {
        getBookListCallCount += 1
        return Just(
            BookList(
                currentPage: "1",
                totalPage: "20",
                books: [
                    Book(
                        id: UUID(),
                        title: "a",
                        subtitle: "b",
                        isbn13: "123",
                        price: "$10",
                        image: "image",
                        url: "url"
                    )
                ]
            ))
        .setFailureType(to: Error.self)
        .eraseToAnyPublisher()
    }
    
    func verifygetBookList(callCount: Int) {
        XCTAssertEqual(getBookListCallCount, callCount)
    }
    
    
}
