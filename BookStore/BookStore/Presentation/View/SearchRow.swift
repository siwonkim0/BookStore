//
//  SearchRow.swift
//  BookStore
//
//  Created by Siwon Kim on 2022/09/21.
//

import Foundation
import SwiftUI

struct SearchRow: View {
    var book: Book
    
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: book.image)) { phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 120)
                } else if phase.error != nil {
                    Color.gray
                } else {
                    ProgressView()
                }
            }.padding(.trailing).frame(width: 100, height: 120)
            VStack(alignment: .leading) {
                Text(book.title)
                    .font(.subheadline)
                    .bold()
                    .padding(.bottom, 0.3)
                Text(book.subtitle)
                    .font(.caption)
                    .foregroundColor(Color.gray)
                    .lineLimit(2)
                Text(book.price)
            }
        }
        
    }
}

struct SearchRow_Previews: PreviewProvider {
    static var previews: some View {
        SearchRow(book: Book(id: UUID(), title: "previewTitle", subtitle: "previewSubtitle", isbn13: "123", price: "100", image: "", url: "https://itbook.store/books/9781783988006"))
            .previewLayout(.fixed(width: 300, height: 70))
    }
}
