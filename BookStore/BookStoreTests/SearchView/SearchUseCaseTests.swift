//
//  SearchUseCaseTests.swift
//  BookStoreTests
//
//  Created by Siwon Kim on 2022/09/22.
//

import XCTest
import Combine

@testable import BookStore

class SearchUseCaseTests: XCTestCase {
    private var cancellables: Set<AnyCancellable>!

    override func setUp() {
        cancellables = Set<AnyCancellable>()
    }
    
    override func tearDown() {
        cancellables = []
    }
    
    func test_totalResultsConvertsToTotalPagesCorrectly() {
        let data = BookListDTO(
            error: "",
            total: "123",
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
        let searchRepository = StubSearchRepository(result: .success(data))
        let searchUseCase = SearchUseCase(searchRepository: searchRepository)
        let promise = expectation(
            description: "받아올 전체 result의 수가 123개이면 totalPage는 13이 되어야한다."
        )
        searchUseCase.getBookList(with: "aa", page: 2)
            .assertNoFailure()
            .eraseToAnyPublisher()
            .sink { bookList in
                let totalPage = Int(bookList.totalPage)!
                if totalPage == 13 {
                    promise.fulfill()
                }
                print(bookList)
            }
            .store(in: &cancellables)
        
        wait(for: [promise], timeout: 1)
    }
    
    func test_totalResultsDividedByTenConvertsToTotalPagesCorrectly() {
        let data = BookListDTO(
            error: "",
            total: "120",
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
        let searchRepository = StubSearchRepository(result: .success(data))
        let searchUseCase = SearchUseCase(searchRepository: searchRepository)
        
        let promise = expectation(
            description: "받아올 전체 result의 수가 120개이면 totalPage는 12가 되어야한다."
        )
        searchUseCase.getBookList(with: "aa", page: 2)
            .assertNoFailure()
            .eraseToAnyPublisher()
            .sink { bookList in
                let totalPage = Int(bookList.totalPage)!
                if totalPage == 12 {
                    promise.fulfill()
                }
            }
            .store(in: &cancellables)
        
        wait(for: [promise], timeout: 1)
    }
    
    func test_makeErrorWhenTotalResultIsZero() {
        let data = BookListDTO(
            error: "",
            total: "0",
            page: "",
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
        let searchRepository = StubSearchRepository(result: .success(data))
        let searchUseCase = SearchUseCase(searchRepository: searchRepository)
        
        let promise = expectation(
            description: "받아올 전체 result의 수가 0개이면 에러를 발생시켜야한다."
        )
        searchUseCase.getBookList(with: "aa", page: 2)
            .sink(receiveCompletion: { error in
                switch error {
                case .failure(_):
                    promise.fulfill()
                case .finished:
                    return
                }
            }, receiveValue: { bookList in
                XCTFail("Should not receive Value")
            })
            .store(in: &cancellables)
        
        wait(for: [promise], timeout: 1)
    }

}
