//
//  SearchRow.swift
//  BookStore
//
//  Created by Siwon Kim on 2022/09/20.
//

import SwiftUI

struct SearchRow: View {
    var book: Book
    
    var body: some View {
        VStack {
            Text(book.title)
            Text(book.subtitle)
        }
    }
}

struct SearchRow_Previews: PreviewProvider {
    static var previews: some View {
        SearchRow(book: Book(id: UUID(), title: "previewTitle", subtitle: "previewSubtitle", isbn13: "123", price: "100", image: "", url: "https://itbook.store/books/9781783988006"))
            .previewLayout(.fixed(width: 300, height: 70))
    }
}
