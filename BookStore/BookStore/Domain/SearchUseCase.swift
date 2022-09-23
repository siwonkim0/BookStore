//
//  SearchUseCase.swift
//  BookStore
//
//  Created by Siwon Kim on 2022/09/19.
//

import Foundation
import Combine

protocol SearchUseCaseType {
    func getBookList(with keyword: String, page: Int) -> AnyPublisher<BookList, Error>
}

final class SearchUseCase: SearchUseCaseType {
    private let searchRepository: SearchRepositoryType
    
    init(searchRepository: SearchRepositoryType) {
        self.searchRepository = searchRepository
    }
    
    func getBookList(with keyword: String, page: Int) -> AnyPublisher<BookList, Error> {
        let page = String(page)
        return searchRepository.getBookList(with: keyword, page: page)
            .compactMap {
                $0.toDomain()
            }
            .eraseToAnyPublisher()
    }
    
}
