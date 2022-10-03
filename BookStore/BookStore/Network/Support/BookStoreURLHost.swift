//
//  BookStoreURLHost.swift
//  BookStore
//
//  Created by Siwon Kim on 2022/09/19.
//

import Foundation

enum BookStoreURLHost {
    case search
    case detail
    
    var urlString: String {
        switch self {
        case .search:
            return "https://api.itbook.store/1.0/search/"
        case .detail:
            return "https://api.itbook.store/1.0/books/"
        }
    }
}
