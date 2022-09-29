//
//  SearchRepositoryType.swift
//  BookStore
//
//  Created by Siwon Kim on 2022/09/19.
//

import Foundation
import Combine

protocol SearchRepositoryType {
    func getResult(with keyword: String, page: String) -> AnyPublisher<BookList, Error>
}
