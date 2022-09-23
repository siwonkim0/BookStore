//
//  NetworkRequest.swift
//  BookStore
//
//  Created by Siwon Kim on 2022/09/19.
//

import Foundation

protocol NetworkRequest {
    associatedtype ResponseType: Decodable
    
    var httpMethod: HttpMethod { get }
    var urlHost: String { get }
    var urlPath: String { get }
    var page: String { get }
    var httpHeader: [String: String]? { get }
    var httpBody: Data? { get }
}

extension NetworkRequest {
    var urlComponents: URL? {
        let urlComponents = URLComponents(string: urlHost + urlPath + "/" + page)
        guard let url = urlComponents?.url else {
            return nil
        }
        return url
    }
    
    var urlRequest: URLRequest? {
        guard let urlComponents = urlComponents else {
            return nil
        }
        var request = URLRequest(url: urlComponents)
        request.httpMethod = httpMethod.description
        request.allHTTPHeaderFields = httpHeader
        request.httpBody = httpBody
        return request
    }
}
