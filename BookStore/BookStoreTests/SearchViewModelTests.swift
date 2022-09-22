//
//  SearchViewModelTests.swift
//  BookStoreTests
//
//  Created by Siwon Kim on 2022/09/19.
//

import XCTest
import Combine

@testable import BookStore

class SearchViewModelTests: XCTestCase {
    private var cancellables: Set<AnyCancellable>!
    private var searchUseCase: SpySearchUseCase!
    private var searchViewModel: SearchViewModel!

    override func setUp() {
        cancellables = Set<AnyCancellable>()
        searchUseCase = SpySearchUseCase()
        searchViewModel = SearchViewModel(searchUseCase: searchUseCase)
    }
    override func tearDown() {
        cancellables = []
        searchUseCase = nil
        searchViewModel = nil
    }
    
    func test_checkDefaultStates() {
        let promise = expectation(
            description: "default state: page = 1, isLastPage = false"
        )
        searchViewModel.$keyword.sink { [weak self] _ in
            if self?.searchViewModel.isLastPage == false && self?.searchViewModel.page == 1 {
                promise.fulfill()
            }
        }.store(in: &cancellables)
        
        wait(for: [promise], timeout: 1)
    }
    
    func test_keywordChangeSetsStatesToDefault() {
        //page가 23이고, isLastPage가 true인 상태에서
        searchViewModel.page = 23
        searchViewModel.isLastPage = true
        let keyword = "none"
        
        let promise = expectation(
            description: "키워드가 바뀌면 page가 1, isLastPage가 false가 된다."
        )
    
        searchViewModel.$books
            .dropFirst()
            .sink { [weak self] books in
                print(books)
                if self?.searchViewModel.isLastPage == false && self?.searchViewModel.page == 1 {
                    promise.fulfill()
                }
                self?.searchUseCase.verifygetBookList(callCount: 1)
            }.store(in: &cancellables)
        
        searchViewModel.keyword = keyword
        wait(for: [promise], timeout: 3)
    }
    
    func test_emptyKeywordMakesBooksEmpty() {
        let keyword = ""
        let promise = expectation(
            description: "키워드가 빈 문자열이라면 books배열이 빈 배열이 된다."
        )
        searchViewModel.$books
            .dropFirst()
            .sink { [weak self] books in
                if books.isEmpty {
                    promise.fulfill()
                }
                self?.searchUseCase.verifygetBookList(callCount: 0)
            }.store(in: &cancellables)
        
        searchViewModel.keyword = keyword
        wait(for: [promise], timeout: 1)
    }
    
    func test_paginationIncrementsPageByOne() {
        searchViewModel.page = 200
        let promise = expectation(
            description: "현재 페이지가 200일때 다음 페이지가 로딩되면 page가 201이 된다."
        )
        
        searchViewModel.$books
            .dropFirst()
            .sink { [weak self] books in
                if self?.searchViewModel.page == 201 {
                    promise.fulfill()
                }
                self?.searchUseCase.verifygetBookList(callCount: 1)
            }.store(in: &cancellables)
        
        searchViewModel.loadMoreBookList()
        wait(for: [promise], timeout: 1)
    }
    
    func test_isLastPageTurnsTrueIfcurrentPageTurnsEqualToTotalPage() {
        searchViewModel.page = 19
        let promise = expectation(
            description: "전체 페이지가 20일때 현재 페이지도 20이 되면 isLastPage가 true가 된다."
        )
        searchViewModel.$books
            .dropFirst()
            .sink { [weak self] books in
                if self!.searchViewModel.isLastPage {
                    promise.fulfill()
                }
                self?.searchUseCase.verifygetBookList(callCount: 1)
            }.store(in: &cancellables)
        
        searchViewModel.loadMoreBookList()
        wait(for: [promise], timeout: 1)
    }
    
    func test_isLastPageTurnsTrueIfTotalPageIsOne() {
        let keyword = "hm"
        searchUseCase.isTotalPageOne = true
        let promise = expectation(
            description: "전체 페이지가 1일때 isLastPage가 true가 된다."
        )
        searchViewModel.$books
            .dropFirst()
            .sink { books in
                if self.searchViewModel.isLastPage {
                    promise.fulfill()
                }
            }.store(in: &cancellables)
        
        searchViewModel.getNewBookList(with: keyword)
        wait(for: [promise], timeout: 1)
    }

}
