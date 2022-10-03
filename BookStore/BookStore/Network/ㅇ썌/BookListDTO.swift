//
//  BookListDTO.swift
//  BookStore
//
//  Created by Siwon Kim on 2022/09/19.
//

import Foundation

struct BookListDTO: Decodable {
    let error, total, page: String?
    let books: [BookDTO]?
}

struct BookDTO: Decodable {
    let title, subtitle, isbn13, price: String
    let image: String
    let url: String
}

extension BookListDTO {
    func toDomain() -> BookList? {
        guard let total = total,
              let totalCount = Int(total),
              let page = page,
              let books = books else {
            return nil
        }
        var totalPage = 0
        if totalCount % 10 == 0 {
            totalPage = totalCount / 10
        } else {
            totalPage = (totalCount / 10) + 1
        }
        return BookList(
            currentPage: page,
            totalPage: String(totalPage),
            books: books.map {
                var price = $0.price
                if $0.price == "$0.00" {
                    price = "Free"
                }
                return Book(
                    id: UUID(),
                    title: $0.title,
                    subtitle: $0.subtitle,
                    isbn13: $0.isbn13,
                    price: price,
                    image: $0.image,
                    url: $0.url,
                    memo: ""
                )
            }
        )
    }
}
