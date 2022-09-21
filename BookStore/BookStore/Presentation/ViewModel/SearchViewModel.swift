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
    
    private var disposables = Set<AnyCancellable>()
    private let searchUseCase: SearchUseCaseType
    
    init(searchUseCase: SearchUseCaseType) {
        self.searchUseCase = searchUseCase
        $keyword
            .dropFirst(1)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.global(qos: .background))
            .print()
            .sink { [weak self] keyword in
                self?.page = 1
                self?.isLastPage = false
                self?.getBookList(with: keyword)
            }
            .store(in: &disposables)
    }
    
    func getBookList(with keyword: String) {
        searchUseCase.getBookList(with: keyword, page: page)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                switch value {
                case let .failure(error):
                    print(error)
                case .finished:
                    if keyword.isEmpty {
                        self?.books = []
                    }
                }
            } receiveValue: { [weak self] bookList in
                
                guard let totalPage = Int(bookList.totalPage),
                      let currentPage = self?.page else {
                    return
                }

                self?.books.append(contentsOf: bookList.books)
                self?.page += 1
                if totalPage == currentPage - 1 { //현재페이지가 전체 페이지수와 같다면 마지막 페이지이다
                    self?.isLastPage = true
                }
            }
            .store(in: &disposables)
    }
    
    func loadMore() {
        getBookList(with: keyword)
    }
    
}
