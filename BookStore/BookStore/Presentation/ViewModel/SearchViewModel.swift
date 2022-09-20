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
    
    private var disposables = Set<AnyCancellable>()
    private let searchUseCase: SearchUseCaseType
    
    init(searchUseCase: SearchUseCaseType) {
        self.searchUseCase = searchUseCase
        $keyword
            .filter { !$0.isEmpty }
            .dropFirst(1)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.global(qos: .background))
            .print()
            .sink(receiveValue: getBookList(with:))
            .store(in: &disposables)
    }
    
    func getBookList(with keyword: String) {
        searchUseCase.getBookList(with: keyword)
            .map { $0.books }
            .receive(on: DispatchQueue.main)
            .sink { value in
                switch value {
                case let .failure(error):
                    print(error)
                case .finished:
                    break
                }
            } receiveValue: { [weak self] books in
                self?.books = books
            }
            .store(in: &disposables)
    }
    
}
