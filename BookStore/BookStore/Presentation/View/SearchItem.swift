//
//  SearchItem.swift
//  BookStore
//
//  Created by Siwon Kim on 2022/09/20.
//

import SwiftUI

struct SearchItem: View {
    var book: Book
    
    var body: some View {
        VStack(alignment: .center) {
            bookImageView
            Text(book.title)
                .font(.caption)
            Text(book.subtitle)
                .font(.caption)
        }
    }
}

extension SearchItem {
    var bookImageView: some View {
        AsyncImage(url: URL(string: book.image)) { phase in
            if let image = phase.image {
                image.resizable()
                    .scaledToFill()
                    .frame(width: 155, height: 170)
                    .aspectRatio(contentMode: .fill)
//                    .clipped()
//                    .cornerRadius(100)
            } else if phase.error != nil {
                Color.gray.frame(width: 155, height: 170)
            } else {
                ProgressView()
            }
        }.foregroundColor(.blue)
    }
}

struct SearchItem_Previews: PreviewProvider {
    static var previews: some View {
        SearchItem(book: Book(
            id: UUID(),
            title: "previewTitle",
            subtitle: "previewSubtitle",
            isbn13: "123",
            price: "100",
            image: "",
            url: "https://itbook.store/img/books/9781484273067.png"
        ))
    }
}
