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
    private var searchRepository: StubSearchRepository!
    private var searchUseCase: SearchUseCase!

    override func setUp() {
        cancellables = Set<AnyCancellable>()
        searchRepository = StubSearchRepository()
        searchUseCase = SearchUseCase(searchRepository: searchRepository)
    }
    
    override func tearDown() {
        cancellables = []
        searchRepository = nil
        searchUseCase = nil
    }
    
    func test_totalResultsConvertsToTotalPagesCorrectly() {
        let promise = expectation(
            description: "받아올 전체 result의 수가 123개이면 totalPage는 13이 된다"
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
    
    func test_totalResultsConvertsToTotalPagesCorrectly2() {
        searchRepository.isTotalResultsDividedIntoTen = true
        
        let promise = expectation(
            description: "받아올 전체 result의 수가 120개이면 totalPage는 12가 된다"
        )
        searchUseCase.getBookList(with: "aa", page: 2)
            .assertNoFailure()
            .eraseToAnyPublisher()
            .sink { bookList in
                let totalPage = Int(bookList.totalPage)!
                if totalPage == 12 {
                    promise.fulfill()
                }
                print(bookList)
            }
            .store(in: &cancellables)
        wait(for: [promise], timeout: 1)
    }

}
