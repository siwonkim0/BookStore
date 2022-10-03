//
//  Publisher+extension.swift
//  BookStore
//
//  Created by Siwon Kim on 2022/10/03.
//

import Foundation
import Combine

extension Publisher {
    func withUnretained<T: AnyObject>(_ object: T) -> Publishers.CompactMap<Self, (T, Self.Output)> {
        compactMap { [weak object] output in
            guard let object = object else {
                return nil
            }
            return (object, output)
        }
    }
}
