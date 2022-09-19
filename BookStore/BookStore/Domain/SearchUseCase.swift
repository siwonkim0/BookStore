//
//  SearchUseCase.swift
//  BookStore
//
//  Created by Siwon Kim on 2022/09/19.
//

import Foundation
import Combine

protocol SearchUseCaseType {
    func getBookList(with keyword: String) -> AnyPublisher<BookList, Error>
}

final class SearchUseCase: SearchUseCaseType {
    private let searchRepository: SearchRepository
    
    init(searchRepository: SearchRepository) {
        self.searchRepository = searchRepository
    }
    
    func getBookList(with keyword: String) -> AnyPublisher<BookList, Error> {
        return searchRepository.getBookList(with: keyword)
            .map {
                $0.toDomain()
            }
            .eraseToAnyPublisher()
    }
    
}
