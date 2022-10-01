//
//  SearchRequest.swift
//  BookStore
//
//  Created by Siwon Kim on 2022/09/19.
//

import Foundation

struct SearchRequest: NetworkRequest {
    typealias ResponseType = BookListDTO
    
    var httpMethod: HttpMethod = .get
    var urlHost: String = BookStoreURLHost.search.description
    var urlPath: String
    var page: String?
    var httpHeader: [String: String]?
    var httpBody: Data?
}
