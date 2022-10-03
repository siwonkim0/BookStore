//
//  SearchView.swift
//  BookStore
//
//  Created by Siwon Kim on 2022/09/19.
//

import SwiftUI

struct SearchView: View {
    @ObservedObject private var viewModel: SearchViewModel
    
    init(viewModel: SearchViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationView {
            ScrollViewReader { proxy in
                ZStack {
                    List {
                        searchResultRows
                        if viewModel.showProgressView {
                            progressView
                        }
                    }
                    .navigationTitle("Books")
                    .alert(isPresented: $viewModel.hasError, error: viewModel.error) { }
                    if viewModel.showIntroView {
                        introView
                    } else {
                        scrollToTopButtonView(id: viewModel.firstSearchResultId, proxy: proxy)
                    }
                }
            }
        }
        .navigationViewStyle(.stack)
        .searchable(text: $viewModel.keyword)
    }
}

private extension SearchView {
    var searchResultRows: some View {
        ForEach(viewModel.books) { book in
            NavigationLink { () -> BookDetailView in
                BookDetailView(
                    viewModel: BookDetailViewModel(
                        book: book,
                        repository: BookDetailRepository(
                            urlSessionManager: URLSessionManager(),
                            coreDataManager: CoreDataManager()
                        )))
            } label: {
                SearchRow(book: book)
                    .id(book.id)
            }
        }.listRowSeparator(.hidden)
    }
        
    var progressView: some View {
        ProgressView("Loading...")
            .progressViewStyle(.circular)
            .frame(maxWidth: .infinity)
            .onAppear {
                viewModel.loadMoreBookList()
            }
    }
    
    var introView: some View {
        VStack {
            Image(systemName: "book.circle")
                .foregroundColor(Color("lightPurple"))
                .imageScale(.large)
            Text("Please start searching by")
            Text("entering keywords")
        }
        .foregroundColor(.gray)
        .font(.headline.weight(.thin))
    }

    func scrollToTopButtonView(id: UUID, proxy: ScrollViewProxy) -> some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button(action: {
                    withAnimation {
                        proxy.scrollTo(id, anchor: .top)
                    }
                }, label: {
                    Image(systemName: "arrow.up.circle.fill")
                }).padding(.trailing, 20)
                    .font(.largeTitle)
                    .foregroundColor(Color("lightPurple"))
            }
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView(viewModel: SearchViewModel(searchRepository: SearchRepository(urlSessionManager: URLSessionManager(urlSession: URLSession.shared), coreDataManager: CoreDataManager())))
    }
}
