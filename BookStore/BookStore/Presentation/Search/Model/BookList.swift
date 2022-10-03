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

class Book: Identifiable, ObservableObject {
    let id: UUID
    let title, subtitle, isbn13, price: String
    let image: String
    let url: String
    var memo: String
    
    init(id: UUID, title: String, subtitle: String, isbn13: String, price: String, image: String, url: String, memo: String) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.isbn13 = isbn13
        self.price = price
        self.image = image
        self.url = url
        self.memo = memo
    }

}
