//
//  TestCoreDataPersistentContainer.swift
//  BookStoreTests
//
//  Created by Siwon Kim on 2022/09/30.
//

import Foundation
import CoreData

final class TestCoreDataPersistentContainer: NSObject {
    static var persistentContainer: NSPersistentContainer = {
        let description = NSPersistentStoreDescription()
        description.url = URL(fileURLWithPath: "/dev/null")
        let container = NSPersistentContainer(name: "SearchResultsContainer")
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Error Loading Core Data. \(error.localizedDescription)")
            } else {
                print("Successfully loaded Core Data for tests")
            }
        }
        return container
    }()
}
