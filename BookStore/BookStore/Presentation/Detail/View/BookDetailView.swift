//
//  BookDetailView.swift
//  BookStore
//
//  Created by Siwon Kim on 2022/09/22.
//

import SwiftUI

struct BookDetailView: View {
    @ObservedObject var viewModel: BookDetailViewModel
    @State private var isWebViewPresented: Bool = false
    @State private var isComfirmationDialogPresented: Bool = false
    @State private var isMemoPresented: Bool = false
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                imageView
                titleView
                subtitleView
                informationsView
            }
            .padding(.all)
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    print("aa")
                } label: {
                    Image(systemName: "ellipsis.circle.fill")
                }
            }
        }
        .onAppear {
            viewModel.getData(with: viewModel.book.isbn13)
        }
    }
}

private extension BookDetailView {
    var imageView: some View {
        AsyncImage(url: URL(string: viewModel.bookDetail.imageUrl)) { phase in
            if let image = phase.image {
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 400, height: 500)
                    .shadow(color: .gray, radius: 10, x: 20, y: 20)
            } else if phase.error != nil {
                Image(systemName: "exclamationmark.circle.fill")
            } else {
                ProgressView()
            }
        }.frame(width: 400, height: 500, alignment: .center)
            .padding(.bottom, -20)
    }
    
    var titleView: some View {
        Text("\(viewModel.book.title)")
            .font(.title2.bold())
    }
    
    var subtitleView: some View {
        VStack(alignment: .center) {
            Text("\(viewModel.book.subtitle)")
                .foregroundColor(.gray)
            Text("\(viewModel.bookDetail.authors)")
                .font(.title3)
            Text("\(viewModel.bookDetail.price)")
            Text("\(viewModel.bookDetail.description)")
        }
    }
    
    var informationsView: some View {
        VStack {
            Divider()
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(alignment: .top) {
                        InformationView(title: "publisher", value: viewModel.bookDetail.publisher, imageName: "rectangle.and.pencil.and.ellipsis")
                            .padding(.all)
                        Divider()
                        InformationView(title: "language", value: viewModel.bookDetail.language, imageName: "textformat.abc")
                            .padding(.all)
                        Divider()
                        InformationView(title: "pages", value: viewModel.bookDetail.bookPages, imageName: "book")
                            .padding(.all)
                        Divider()
                        InformationView(title: "year", value: viewModel.bookDetail.year, imageName: "calendar")
                            .padding(.all)
                        Divider()
                        InformationView(title: "ratings", value: viewModel.bookDetail.rating, imageName: "star.leadinghalf.filled")
                            .padding(.all)
                }
            }
            Divider()
        }
    }
}

struct BookDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let book = Book(id: UUID(), title: "book", subtitle: "sub", isbn13: "sub", price: "sub", image: "sub", url: "sub", memo: "sub")
        BookDetailView(viewModel: BookDetailViewModel(book: book, repository: BookDetailRepository(urlSessionManager: URLSessionManager())))
    }
}
