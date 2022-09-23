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
    
    func getBookList(with keyword: String, page: String) -> AnyPublisher<BookListDTO, Error> {
        //total이 10의 배수인 경우와 아닌 경우 둘다를 테스트하고 싶어서 조건에 따라 다른 값을 내려주도록 설정
        var totalResults = "123"
        if isTotalResultsDividedIntoTen {
            totalResults = "120"
        }
        return Just(
            BookListDTO(
                error: "",
                total: totalResults,
                page: "2",
                books: [
                    BookDTO(
                        title: "swift",
                        subtitle: "is fun",
                        isbn13: "12345",
                        price: "$20",
                        image: "imageurl",
                        url: "url"
                    )
                ]
            )
        )
        .setFailureType(to: Error.self)
        .eraseToAnyPublisher()
    }
    
    
}
