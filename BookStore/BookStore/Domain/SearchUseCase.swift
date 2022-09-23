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
        return searchRepository.getBookList(with: keyword, page: String(page))
            .tryMap { bookListDTO -> BookListDTO in
                if bookListDTO.total == "0" {
                    throw URLSessionError.invaildData
                } else {
                    return bookListDTO
                }
            }
            .eraseToAnyPublisher()
            .compactMap { $0.toDomain() }
            .eraseToAnyPublisher()
    }
    
}

