//
//  SpyURLSessionManager.swift
//  BookStoreTests
//
//  Created by Siwon Kim on 2022/09/30.
//

import XCTest
import Combine

@testable import BookStore

final class SpyURLSessionManager: URLSessionManagerType {
    private var performDataTaskCallCount: Int = 0
    private var data: Data
    
    init(data: Data) {
        self.data = data
    }
    
    func performDataTask<T>(urlRequest: T) -> AnyPublisher<T.ResponseType, Error> where T : NetworkRequest {
        performDataTaskCallCount += 1
        guard let decodedObject = try? JSONDecoder().decode(T.ResponseType.self, from: data) else {
            return Fail(error: URLSessionError.decodingFailed).eraseToAnyPublisher()
        }
        return Just(decodedObject)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    func verifyPerformDataTask(callCount: Int) {
        XCTAssertEqual(performDataTaskCallCount, callCount)
    }
    
}
