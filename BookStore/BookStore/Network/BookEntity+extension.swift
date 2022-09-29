//
//  BookEntity+extension.swift
//  BookStore
//
//  Created by Siwon Kim on 2022/09/29.
//

import Foundation

extension BookEntity {
    func toDomain() -> Book {
        Book(
            id: self.id ?? UUID(),
            title: self.title ?? "",
            subtitle: self.subtitle ?? "",
            isbn13: self.isbn13 ?? "",
            price: self.price ?? "",
            image: self.imageUrl ?? "",
            url: self.url ?? ""
        )
    }
}
