//
//  SearchRepositoryType.swift
//  BookStore
//
//  Created by Siwon Kim on 2022/09/19.
//

import Foundation
import Combine

protocol SearchRepositoryType {
    func getBookList(with keyword: String, page: String) -> AnyPublisher<BookListDTO, Error>
}
