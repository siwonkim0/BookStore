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

    func test_키워드가_바뀌면_page가_1_isLastPage가_false가_되어야한다() {
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
        let searchRepository = SpySearchRepository(
            result: .success(data)
        )
        let searchViewModel = SearchViewModel(searchRepository: searchRepository)
        
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

    func test_현재_페이지가_200일때_다음_페이지가_로딩되면_page가_201이_되어야한다() {
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
        let searchRepository = SpySearchRepository(
            result: .success(data)
        )
        let searchViewModel = SearchViewModel(searchRepository: searchRepository)
        
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
                searchRepository.verifygetResult(callCount: 1)
            }.store(in: &cancellables)

        searchViewModel.loadMoreBookList()
        wait(for: [promise], timeout: 1)
    }
    
    func test_response_data가_1페이지일때_isLastPage가_true가_되어야한다() {
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
        let searchRepository = SpySearchRepository(
            result: .success(data)
        )
        let searchViewModel = SearchViewModel(searchRepository: searchRepository)
    
        let promise = expectation(
            description: "response data가 1페이지일때 isLastPage가 true가 되어야한다."
        )
        searchViewModel.$books
            .dropFirst()
            .sink { books in
                if searchViewModel.isLastPage {
                    promise.fulfill()
                    searchRepository.verifygetResult(callCount: 1)
                }
            }.store(in: &cancellables)
        
        searchViewModel.getNewBookList(with: "")
        wait(for: [promise], timeout: 1)
    }
    
    func test_잘못된_키워드로_요청했을때_에러가_발생하면_books가_빈_배열이_되어야한다() {
        let searchRepository = SpySearchRepository(
            result: .failure(URLSessionError.invalidData)
        )
        let searchViewModel = SearchViewModel(searchRepository: searchRepository)
        let promise = expectation(
            description: "잘못된 키워드로 요청했을때 에러가 발생하면 books가 빈 배열이 되어야한다."
        )
        searchViewModel.$books
            .dropFirst()
            .sink { books in
                if searchViewModel.books.isEmpty {
                    promise.fulfill()
                    searchRepository.verifygetResult(callCount: 1)
                }
            }.store(in: &cancellables)
        
        searchViewModel.getNewBookList(with: "")
        wait(for: [promise], timeout: 1)
    }
    
    func test_다음_페이지를_요청했을때_에러가_발생하면_isLastPage가_true가_되어야한다() {
        let searchRepository = SpySearchRepository(
            result: .failure(URLSessionError.invalidData)
        )
        let searchViewModel = SearchViewModel(searchRepository: searchRepository)
        let promise = expectation(
            description: "다음 페이지를 요청했을때 에러가 발생하면 isLastPage가 true가 되어야한다."
        )
        searchViewModel.$books
            .dropFirst()
            .sink { books in
                if searchViewModel.isLastPage {
                    promise.fulfill()
                    searchRepository.verifygetResult(callCount: 1)
                }
            }.store(in: &cancellables)
        
        searchViewModel.loadMoreBookList()
        wait(for: [promise], timeout: 1)
    }
    


}
