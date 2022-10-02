//
//  SearchViewModelTests.swift
//  BookStoreTests
//
//  Created by Siwon Kim on 2022/09/19.
//

import XCTest
import Combine

@testable import BookStore

final class SearchViewModelTests: XCTestCase {
    private var cancellables: Set<AnyCancellable>!

    override func setUp() {
        cancellables = Set<AnyCancellable>()
    }
    override func tearDown() {
        cancellables = []
    }

    func test_keywordChangeSetsStatesToDefault() {
        let data = BookList(
            currentPage: "1",
            totalPage: "10",
            books: [
                Book(
                    id: UUID(),
                    title: "a",
                    subtitle: "b",
                    isbn13: "123",
                    price: "$10",
                    image: "image",
                    url: "url",
                    memo: ""
                )
            ]
        )
        let searchUseCase = SpySearchUseCase(
            result: .success(data)
        )
        let searchViewModel = SearchViewModel(searchUseCase: searchUseCase)
        
        //page가 23이고, isLastPage가 true인 상태에서
        searchViewModel.page = 23
        searchViewModel.isLastPage = true
        let keyword = "none"

        let promise = expectation(
            description: "키워드가 바뀌면 page가 1, isLastPage가 false가 되어야한다."
        )

        searchViewModel.$books
            .dropFirst()
            .sink { _ in
                if searchViewModel.isLastPage == false && searchViewModel.page == 1 && searchViewModel.books.isEmpty {
                    promise.fulfill()
                }
            }.store(in: &cancellables)

        searchViewModel.keyword = keyword
        wait(for: [promise], timeout: 1)
    }

    func test_paginationIncrementsPageByOne() {
        let data = BookList(
            currentPage: "200",
            totalPage: "500",
            books: [
                Book(
                    id: UUID(),
                    title: "a",
                    subtitle: "b",
                    isbn13: "123",
                    price: "$10",
                    image: "image",
                    url: "url",
                    memo: ""
                )
            ]
        )
        let searchUseCase = SpySearchUseCase(
            result: .success(data)
        )
        let searchViewModel = SearchViewModel(searchUseCase: searchUseCase)
        
        searchViewModel.page = 200
        let promise = expectation(
            description: "현재 페이지가 200일때 다음 페이지가 로딩되면 page가 201이 되어야한다."
        )

        searchViewModel.$books
            .dropFirst()
            .sink { books in
                if searchViewModel.page == 201 {
                    promise.fulfill()
                }
                searchUseCase.verifygetBookList(callCount: 1)
            }.store(in: &cancellables)

        searchViewModel.loadMoreBookList()
        wait(for: [promise], timeout: 1)
    }
    
    func test_isLastPageTurnsTrueWhenTotalPageIsOne() {
        let data = BookList(
            currentPage: "1",
            totalPage: "1",
            books: [
                Book(
                    id: UUID(),
                    title: "a",
                    subtitle: "b",
                    isbn13: "123",
                    price: "$10",
                    image: "image",
                    url: "url",
                    memo: ""
                )
            ]
        )
        let searchUseCase = SpySearchUseCase(
            result: .success(data)
        )
        let searchViewModel = SearchViewModel(searchUseCase: searchUseCase)
        let promise = expectation(
            description: "response data가 1페이지일때 isLastPage가 true가 되어야한다."
        )
        searchViewModel.$books
            .dropFirst()
            .sink { books in
                if searchViewModel.isLastPage {
                    promise.fulfill()
                    searchUseCase.verifygetBookList(callCount: 1)
                }
            }.store(in: &cancellables)
        
        searchViewModel.getNewBookList(with: "")
        wait(for: [promise], timeout: 1)
    }
    
    func test_booksGetsEmptiedWhenInvalidKeywordEntered() {
        let searchUseCase = SpySearchUseCase(
            result: .failure(URLSessionError.invalidData)
        )
        let searchViewModel = SearchViewModel(searchUseCase: searchUseCase)
        let promise = expectation(
            description: "잘못된 키워드로 요청했을때 에러가 발생하면 books가 빈 배열이 되어야한다."
        )
        searchViewModel.$books
            .dropFirst()
            .sink { books in
                if searchViewModel.books.isEmpty {
                    promise.fulfill()
                    searchUseCase.verifygetBookList(callCount: 1)
                }
            }.store(in: &cancellables)
        
        searchViewModel.getNewBookList(with: "")
        wait(for: [promise], timeout: 1)
    }
    
    func test_isLastPageTurnsTrueWhenPaginationFailed() {
        let searchUseCase = SpySearchUseCase(
            result: .failure(URLSessionError.invalidData)
        )
        let searchViewModel = SearchViewModel(searchUseCase: searchUseCase)
        let promise = expectation(
            description: "다음 페이지를 요청했을때 에러가 발생하면 isLastPage가 true가 되어야한다."
        )
        searchViewModel.$books
            .dropFirst()
            .sink { books in
                if searchViewModel.isLastPage {
                    promise.fulfill()
                    searchUseCase.verifygetBookList(callCount: 1)
                }
            }.store(in: &cancellables)
        
        searchViewModel.loadMoreBookList()
        wait(for: [promise], timeout: 1)
    }
    


}
