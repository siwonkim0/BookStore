//
//  SearchView.swift
//  BookStore
//
//  Created by Siwon Kim on 2022/09/19.
//

import SwiftUI

struct SearchView: View {
    @EnvironmentObject private var viewModel: SearchViewModel
    private var gridItemLayout = [GridItem(.flexible()), GridItem(.flexible())]
    
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    searchTextField
                    LazyVGrid(
                        columns: gridItemLayout,
                        alignment: .center,
                        spacing: 5
                    ) {
                        if viewModel.books.isEmpty {
                            emptySection
                        } else {
                            resultSection
                        }
                    }
                }
                .padding(.horizontal)
            }
            .onAppear {
                //TODO: 초기데이터 변경
                viewModel.getBookList(with: "db")
            }
            .navigationTitle("Books")
        }
    }
}

extension SearchView {
    var searchTextField: some View {
        HStack(alignment: .center) {
            TextField("Search: e.g MongoDB", text: $viewModel.keyword)
                .background(.blue)
        }
    }
    
    var resultSection: some View {
        Section {
            ForEach(viewModel.books) { count in
                VStack {
                    SearchItem(book: count)
                }
            }
        }
    }
    
    var emptySection: some View {
        Section {
            Text("No results")
                .foregroundColor(.gray)
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
            .environmentObject(SearchViewModel(searchUseCase: SearchUseCase(searchRepository: SearchRepository(urlSessionManager: URLSessionManager(urlSession: URLSession.shared)))))
    }
}
