//
//  BookListDTO.swift
//  BookStore
//
//  Created by Siwon Kim on 2022/09/19.
//

import Foundation

struct BookListDTO: Decodable {
    let error, total, page: String
    let books: [BookDTO]
}

struct BookDTO: Decodable {
    let title, subtitle, isbn13, price: String
    let image: String
    let url: String
}
