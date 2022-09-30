//
//  CoreDataError.swift
//  BookStore
//
//  Created by Siwon Kim on 2022/09/29.
//

import Foundation

enum CoreDataError: Error {
    case invalidData
    
    var errorDescription: String {
        switch self {
        case .invalidData:
            return "invalidData"
        }
    }
}
