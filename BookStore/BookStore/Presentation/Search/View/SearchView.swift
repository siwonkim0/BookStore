//
//  SearchView.swift
//  BookStore
//
//  Created by Siwon Kim on 2022/09/19.
//

import SwiftUI

struct SearchView: View {
    @EnvironmentObject private var viewModel: SearchViewModel
    
    var body: some View {
        navigationListView
            .searchable(text: $viewModel.keyword) //뷰의 text가 바뀌면 뷰모델의 키워드도 변경하겠다는 바인딩
    }
}

private extension SearchView {
    var navigationListView: some View {
        NavigationView {
            ScrollViewReader { proxy in
                ZStack {
                    List {
                        ForEach(viewModel.books) { book in
                            NavigationLink {
                                BookDetailView(isMemo: $viewModel.isMemo)
                            } label: {
                                SearchRow(isMemo: $viewModel.isMemo, book: book)
                                    .id(book.id)
                            }
                        }.listRowSeparator(.hidden)
                        
                        if !viewModel.isLastPage && !viewModel.books.isEmpty {
                            progressView
                        }
                    }
                    .navigationTitle("Books")
                    
                    if viewModel.books.isEmpty {
                        introView
                    } else {
                        ScrollToTopButtonView(id: viewModel.books[0].id, proxy: proxy)
                    }
                }
            }
        }
        .navigationViewStyle(.stack)
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
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
            .environmentObject(SearchViewModel(searchUseCase: SearchUseCase(searchRepository: SearchRepository(urlSessionManager: URLSessionManager(urlSession: URLSession.shared), coreDataManager: CoreDataManager()))))
    }
}
