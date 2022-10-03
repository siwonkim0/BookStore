//
//  URLSessionError.swift
//  BookStore
//
//  Created by Siwon Kim on 2022/09/19.
//

import Foundation

enum URLSessionError: LocalizedError {
    case networkUnavailable
    case invalidRequest
    case responseFailed
    case invalidData
    case invalidURL
    case decodingFailed
}

extension URLSessionError {
    var errorDescription: String? {
        switch self {
        case .networkUnavailable:
            return "The Internet connection appears to be offline"
        case .invalidRequest:
            return "Request appears to be not valid"
        case .responseFailed:
            return "Response appears to be failed"
        case .invalidData:
            return "Response data appears to be not valid"
        case .invalidURL:
            return "URL appears to be not valid"
        case .decodingFailed:
            return "Decoding appears to be failed"
        }
    }
}
