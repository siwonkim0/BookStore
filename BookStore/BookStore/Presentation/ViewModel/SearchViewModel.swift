//
//  SearchViewModel.swift
//  BookStore
//
//  Created by Siwon Kim on 2022/09/19.
//

import Foundation
import Combine

final class SearchViewModel: ObservableObject {
    private let searchUseCase: SearchUseCaseType
    
    init(searchUseCase: SearchUseCaseType) {
        self.searchUseCase = searchUseCase
    }
    
    func getBookList(with keyword: String) -> AnyPublisher<BookList, Error> {
        return searchUseCase.getBookList(with: keyword)
    }
    
}
