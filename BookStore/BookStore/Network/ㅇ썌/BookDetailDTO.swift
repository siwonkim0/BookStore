//
//  BookDetailDTO.swift
//  BookStore
//
//  Created by Siwon Kim on 2022/10/01.
//

import Foundation

struct BookDetailDTO: Decodable {
    let error, title, subtitle, authors: String
    let publisher, language, isbn10, isbn13: String
    let pages, year, rating, desc: String
    let price: String
    let image: String
    let url: String
    let pdf: PDF?
}

extension BookDetailDTO {
    func toDomain() -> BookDetail {
        return BookDetail(
            title: self.title,
            subtitle: self.subtitle,
            authors: self.authors,
            publisher: self.publisher,
            language: self.language,
            isbn13: self.isbn13,
            bookPages: self.pages,
            year: self.year,
            rating: self.rating,
            description: self.desc,
            price: self.price,
            imageUrl: self.image,
            url: self.url,
            pdf: self.pdf ?? PDF(chapter2: "", chapter5: "")
        )
    }
}

struct PDF: Decodable {
    let chapter2, chapter5: String

    enum CodingKeys: String, CodingKey {
        case chapter2 = "Chapter 2"
        case chapter5 = "Chapter 5"
    }
}
