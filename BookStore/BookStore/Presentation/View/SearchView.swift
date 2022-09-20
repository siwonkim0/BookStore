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
            NavigationView {
                List {
                    searchTextField
                    if viewModel.books.isEmpty {
                        emptySection
                    } else {
                        resultSection
                    }
                }.navigationTitle("Books")
            }
        }
    }

    private extension SearchView {
        var searchTextField: some View {
            HStack(alignment: .center) {
                TextField("Search: e.g MongoDB", text: $viewModel.keyword)
            }
        }
        
        var resultSection: some View {
            Section {
                ForEach(viewModel.books) { book in
                    SearchRow(book: book)
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
    }
}
