//
//  SearchViewModel.swift
//  BookStore
//
//  Created by Siwon Kim on 2022/09/19.
//

import Foundation
import Combine

final class SearchViewModel: ObservableObject, Identifiable {
    @Published var keyword: String = ""
    @Published var books: [Book] = []
    var page: Int = 1
    var isLastPage = false
    
    private var cancellables = Set<AnyCancellable>()
    private let searchUseCase: SearchUseCaseType
    
    init(searchUseCase: SearchUseCaseType) {
        self.searchUseCase = searchUseCase
        subscribeKeyword()
    }
    
    private func subscribeKeyword() {
        $keyword
            .dropFirst(1)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .print()
            .sink { [weak self] keyword in
                guard let self = self else {
                    return
                }
                if keyword.isEmpty {
                    self.books = []
                }
                self.page = 1
                self.isLastPage = false
                self.getNewBookList(with: keyword)
            }
            .store(in: &cancellables)
    }
    
    func getNewBookList(with keyword: String) {
        searchUseCase.getBookList(with: keyword, page: page)
            .receive(on: DispatchQueue.main)
            .sink { _ in } receiveValue: { [weak self] bookList in
                guard let self = self,
                      let totalPage = Int(bookList.totalPage) else {
                    return
                }
                if totalPage == self.page {
                    self.isLastPage = true
                }
                self.books = bookList.books
            }
            .store(in: &cancellables)
    }
    
    func loadMoreBookList() {
        searchUseCase.getBookList(with: keyword, page: page)
            .receive(on: DispatchQueue.main)
            .sink { _ in } receiveValue: { [weak self] bookList in
                guard let self = self,
                      let totalPage = Int(bookList.totalPage) else {
                    return
                }
                self.page += 1
                if totalPage == self.page {
                    self.isLastPage = true
                }
                self.books.append(contentsOf: bookList.books)
            }
            .store(in: &cancellables)
    }
    
}
