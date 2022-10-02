//
//  BookDetailView.swift
//  BookStore
//
//  Created by Siwon Kim on 2022/09/22.
//

import SwiftUI

struct BookDetailView: View {
    @ObservedObject var viewModel: BookDetailViewModel = BookDetailViewModel(repository: BookDetailRepository(urlSessionManager: URLSessionManager()))
    @EnvironmentObject var book: Book //memo때문에 two way binding
    @State private var isWebViewPresented: Bool = false
    @Binding var isMemo: Bool
    @State private var memoText: String = "sds"
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                VStack {
                    imageView
                    titleView
                    subtitleView
                    informationsView
                }
                Button("link") {
                    isWebViewPresented = true
                }
                .sheet(isPresented: $isWebViewPresented) { //모달창이 내려가면 자동으로 false
                    WebView(url: URL(string: "https://itbook.store/books/9781849517744")!)
                }
                descriptionView
                textEditorView
                submitButton
            }
            .padding(.all)
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(content: {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    print("aa")
                } label: {
                    Image(systemName: "ellipsis.circle.fill")
                }

            }
        })
        
        .onAppear {
            viewModel.getData(with: book.isbn13)
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
        Text("\(book.title)")
            .font(.title2.bold())
    }
    
    var subtitleView: some View {
        VStack {
            Text("\(book.subtitle)")
                .foregroundColor(.gray)
            Text("\(viewModel.bookDetail.authors)")
                .font(.title3)
            Text("\(viewModel.bookDetail.price)")
            Text("\(viewModel.bookDetail.description)")
                .padding()
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
    
    var textEditorView: some View {
        TextEditor(text: $memoText)
            .frame(height: 250)
            .padding(.all, .maximum(5, 5))
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(.gray))
    }
    
    var descriptionView: some View {
        Text("you can take memo here")
    }
    
    var submitButton: some View {
        Button("save") {
            print("aaaa")
        }
    }
}

struct BookDetailView_Previews: PreviewProvider {
    static var previews: some View {
        BookDetailView(isMemo: .constant(true))
            .environmentObject(Book(id: UUID(), title: "book", subtitle: "sub", isbn13: "123", price: "$12", image: "aa", url: "aa"))
    }
}
