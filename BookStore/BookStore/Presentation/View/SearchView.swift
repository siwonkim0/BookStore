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
            .searchable(text: $viewModel.keyword)
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
                                BookDetailView()
                            } label: {
                                SearchRow(book: book)
                                    .id(book.id)
                            }
                        }.listRowSeparator(.hidden)
                        if !viewModel.isLastPage && !viewModel.keyword.isEmpty && !viewModel.books.isEmpty {
                            progressView
                        }
                    }
                    .navigationTitle("Books")
                    if !viewModel.keyword.isEmpty && !viewModel.books.isEmpty {
                        VStack {
                            Spacer()
                            HStack {
                                Spacer()
                                Button(action: {
                                    proxy.scrollTo(viewModel.books[0].id, anchor: .top)
                                }, label: {
                                    Image(systemName: "arrow.up.circle.fill")
                                }).padding(.trailing, 20)
                                    .font(.largeTitle)
                                    .foregroundColor(Color("lightPurple"))
                            }
                        }
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
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
            .environmentObject(SearchViewModel(searchUseCase: SearchUseCase(searchRepository: SearchRepository(urlSessionManager: URLSessionManager(urlSession: URLSession.shared)))))
    }
}
