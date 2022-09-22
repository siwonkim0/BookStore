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
    var isTotalPageOne: Bool = false
    private var getBookListCallCount: Int = 0
    
    func getBookList(with keyword: String, page: Int) -> AnyPublisher<BookList, Error> {
        getBookListCallCount += 1
        //totalPage가 1인 경우와 아닌 경우 둘다를 테스트하고 싶어서 조건에 따라 다른 값을 내려주도록 설정
        var totalPage = "20"
        if isTotalPageOne {
            totalPage = "1"
        }
        
        return Just(
            BookList(
                currentPage: "1",
                totalPage: totalPage,
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
