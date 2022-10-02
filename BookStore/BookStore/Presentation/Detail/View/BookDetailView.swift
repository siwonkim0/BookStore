//
//  BookDetailView.swift
//  BookStore
//
//  Created by Siwon Kim on 2022/09/22.
//

import SwiftUI

struct BookDetailView: View {
    @ObservedObject private var viewModel: BookDetailViewModel
    
    init(viewModel: BookDetailViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                imageView
                titleView
                subtitleView
                informationsView
                addMemoButton
                visitWebsiteButton
            }
            .padding(.all)
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                toolBarButton
            }
            
        }.onAppear {
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
    
    var toolBarButton: some View {
        Button() {
            viewModel.isComfirmationDialogPresented = true
        } label: {
            Image(systemName: "ellipsis.circle.fill")
        }
        .confirmationDialog("add memo", isPresented: $viewModel.isComfirmationDialogPresented, titleVisibility: .visible) {
            addMemoButton
            visitWebsiteButton
        }
    }
    
    var addMemoButton: some View {
        Button("add memo") {
            viewModel.isMemoPresented = true
        }.sheet(isPresented: $viewModel.isMemoPresented) {
            MemoView(book: $viewModel.book, isMemoPresented: $viewModel.isMemoPresented)
        }
    }
    
    var visitWebsiteButton: some View {
        Button("visit website") {
            viewModel.isWebViewPresented = true
        }
        .sheet(isPresented: $viewModel.isWebViewPresented) {
            WebView(url: URL(string: viewModel.book.url)!)
        }
    }
    
    var informationsView: some View {
        VStack {
            Divider()
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top) {
                    informationView(title: "publisher", value: viewModel.bookDetail.publisher, imageName: "rectangle.and.pencil.and.ellipsis")
                        .padding(.all)
                    Divider()
                    informationView(title: "language", value: viewModel.bookDetail.language, imageName: "textformat.abc")
                        .padding(.all)
                    Divider()
                    informationView(title: "pages", value: viewModel.bookDetail.bookPages, imageName: "book")
                        .padding(.all)
                    Divider()
                    informationView(title: "year", value: viewModel.bookDetail.year, imageName: "calendar")
                        .padding(.all)
                    Divider()
                    informationView(title: "ratings", value: viewModel.bookDetail.rating, imageName: "star.leadinghalf.filled")
                        .padding(.all)
                }
            }
            Divider()
        }
    }
    
    func informationView(title: String, value: String, imageName: String) -> some View {
        VStack(alignment: .center) {
            Text(title)
                .foregroundColor(.gray)
                .padding(.bottom)
            Spacer()
            Image(systemName: imageName)
                .font(.largeTitle)
                .padding(.bottom)
            Spacer()
            Text(value)
                .font(.callout)
                .frame(width: 80, height: 20)
                .minimumScaleFactor(0.5)
        }
        .frame(width: 80, height: 100)
    }
}

struct BookDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let book = Book(id: UUID(), title: "book", subtitle: "sub", isbn13: "sub", price: "sub", image: "sub", url: "sub", memo: "sub")
        BookDetailView(viewModel: BookDetailViewModel(book: book, repository: BookDetailRepository(urlSessionManager: URLSessionManager())))
    }
}
