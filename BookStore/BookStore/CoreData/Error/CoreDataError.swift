//
//  CoreDataError.swift
//  BookStore
//
//  Created by Siwon Kim on 2022/09/29.
//

import Foundation

enum CoreDataError: LocalizedError {
    case invalidData
    case failedToSave
    case failedToAdd
    case failedToDelete
    case failedToUpdate
}

extension CoreDataError {
    var errorDescription: String {
        switch self {
        case .invalidData:
            return "invalidData"
        case .failedToSave:
            return "failedToSave"
        case .failedToAdd:
            return "failedToAdd"
        case .failedToDelete:
            return "failedToDelete"
        case .failedToUpdate:
            return "failedToUpdate"
        }
    }
}
