//
//  SearchViewModel.swift
//  BookStore
//
//  Created by Siwon Kim on 2022/09/19.
//

import Foundation
import Combine

final class SearchViewModel: ObservableObject {
    @Published var error: URLSessionError?
    @Published var hasError = false
    @Published var keyword: String = ""
    @Published var books: [Book] = []
    var page: Int = 1
    var isLastPage = false
    
    private var cancellables = Set<AnyCancellable>()
    private let searchRepository: SearchRepositoryType
    
    init(searchRepository: SearchRepositoryType) {
        self.searchRepository = searchRepository
        subscribeKeyword()
    }
    
    func getNewBookList(with keyword: String) {
        getBookList()
            .sink { [weak self] bookList in
                guard let self = self else {
                    return
                }
                if bookList.totalPage == "1" {
                    self.isLastPage = true
                }
                self.books = bookList.books
            }
            .store(in: &cancellables)
    }
    
    func loadMoreBookList() {
        self.page += 1
        getBookList()
            .map { [weak self] bookList -> BookList in
                if bookList.books.isEmpty {
                    self?.isLastPage = true
                }
                return bookList
            }
            .sink { [weak self] bookList in
                guard let self = self else {
                    return
                }
                self.books.append(contentsOf: bookList.books)
            }
            .store(in: &cancellables)
    }
    
    private func getBookList() -> AnyPublisher<BookList, Never> {
        searchRepository.getResult(with: keyword, page: String(page))
            .receive(on: DispatchQueue.main)
            .catch { [weak self] error -> AnyPublisher<BookList, Never> in
                if let error = error as? URLSessionError, case .networkUnavailable = error {
                    self?.hasError = true
                    self?.error = error
                }
                return Just(
                    BookList(
                        currentPage: "",
                        totalPage: "",
                        books: []
                    ))
                .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
    
    private func subscribeKeyword() {
        $keyword
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .sink { [weak self] keyword in
                guard let self = self else {
                    return
                }
                self.resetStates()
                if keyword.count > 1 {
                    self.getNewBookList(with: keyword)
                }
            }
            .store(in: &cancellables)
    }
}

extension SearchViewModel {
    var showProgressView: Bool {
        !isLastPage && !books.isEmpty
    }
    
    var showIntroView: Bool {
        books.isEmpty
    }
    
    var firstSearchResultId: UUID {
        books[0].id
    }
    
    func resetStates() {
        self.page = 1
        self.isLastPage = false
        self.books = []
    }
}
