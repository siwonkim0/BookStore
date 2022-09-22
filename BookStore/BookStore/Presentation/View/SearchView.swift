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
                List {
                    ForEach(viewModel.books) { book in
                        NavigationLink {
                            BookDetailView()
                        } label: {
                            SearchRow(book: book)
                        }
                    }.listRowSeparator(.hidden)
                    if !viewModel.isLastPage && !viewModel.keyword.isEmpty {
                        progressView
                    }
                }
                .navigationTitle("Books")
            }
            .navigationViewStyle(.stack)
        }
        
        var progressView: some View {
            ProgressView()
                .progressViewStyle(.circular)
                .frame(maxWidth: .infinity)
                .onAppear {
                    viewModel.loadMore()
                }
        }
    }

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
            .environmentObject(SearchViewModel(searchUseCase: SearchUseCase(searchRepository: SearchRepository(urlSessionManager: URLSessionManager(urlSession: URLSession.shared)))))
    }
}
