//
//  URLSessionProtocol.swift
//  BookStore
//
//  Created by Siwon Kim on 2022/09/19.
//

import Foundation

protocol URLSessionProtocol {
    func dataTaskPublisher(for url: URLRequest) -> URLSession.DataTaskPublisher
}

extension URLSession: URLSessionProtocol {

}
