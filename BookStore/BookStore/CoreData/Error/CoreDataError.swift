//
//  CoreDataError.swift
//  BookStore
//
//  Created by Siwon Kim on 2022/09/29.
//

import Foundation

enum CoreDataError: Error {
    case invalidData
    case failedToSave
    case failedToAdd
    case failedToDelete
    
    var errorDescription: String {
        switch self {
        case .invalidData:
            return "invalidData"
        case .failedToSave:
            return "failedToSave"
        case .failedToAdd:
            return "failedToAdd"
        case .failedToDelete:
            return "failedToAdd"
        }
    }
}
