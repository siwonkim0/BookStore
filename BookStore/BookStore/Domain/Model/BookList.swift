//
//  BookList.swift
//  BookStore
//
//  Created by Siwon Kim on 2022/09/19.
//

import Foundation

struct BookList {
    let currentPage: String
    let totalPage: String
    let books: [Book]
}

struct Book: Identifiable {
    let id: UUID
    let title, subtitle, isbn13, price: String
    let image: String
    let url: String
}
