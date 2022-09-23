//
//  BookStoreApp.swift
//  BookStore
//
//  Created by Siwon Kim on 2022/09/19.
//

import SwiftUI

@main
struct BookStoreApp: App {
    @StateObject var viewModel = SearchViewModel(
        searchUseCase: SearchUseCase(
            searchRepository: SearchRepository(
                urlSessionManager: URLSessionManager(
                    urlSession: URLSession.shared
                ))))
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
        }
    }
}
