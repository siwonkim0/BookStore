//
//  SearchRepositoryTests.swift
//  BookStoreTests
//
//  Created by Siwon Kim on 2022/09/30.
//

import XCTest
import Combine

@testable import BookStore

final class SearchRepositoryTests: XCTestCase {
    private var cancellables: Set<AnyCancellable>!

    override func setUp() {
        cancellables = Set<AnyCancellable>()
    }
    
    override func tearDown() {
        cancellables = []
    }
    
    func test_CoreData에_캐시되어있지_않다면_서버에서_새로_받아온다() {
        guard let path = Bundle.main.path(forResource: "BookListData", ofType: "json"),
              let jsonString = try? String(contentsOfFile: path),
              let data = jsonString.data(using: .utf8) else {
            return
        }

        let urlSessionManager = SpyURLSessionManager(data: data)
        let coreDataManager = SpyCoreDataManager(result: .failure(CoreDataError.invalidData))
        let searchRepository = SearchRepository(urlSessionManager: urlSessionManager, coreDataManager: coreDataManager)
        
        let promise = expectation(
            description: "CoreData에 캐시되어있지 않다면 서버에서 새로 받아온다."
        )
        
        searchRepository.getResult(with: "data", page: "1")
            .assertNoFailure()
            .sink { bookList in
                coreDataManager.verifyFetch(callCount: 1)
                coreDataManager.verifyAdd(callCount: 1)
                urlSessionManager.verifyPerformDataTask(callCount: 1)
                
                if bookList.totalPage == "177" {
                    promise.fulfill()
                }
            }
            .store(in: &cancellables)
        
        wait(for: [promise], timeout: 1)
    }
    
    func test_CoreData에_캐시되어있다면_캐시_데이터를_불러온다() {
        let coreDataContext = TestCoreDataPersistentContainer.persistentContainer.viewContext
        let bookEntity = BookEntity(context: coreDataContext)
        bookEntity.totalPage = "10"

        let urlSessionManager = SpyURLSessionManager(data: Data())
        let coreDataManager = SpyCoreDataManager(result: .success([bookEntity]))
        let searchRepository = SearchRepository(urlSessionManager: urlSessionManager, coreDataManager: coreDataManager)
        
        let promise = expectation(
            description: "CoreData에 캐시되어있다면 캐시 데이터를 불러온다."
        )
        
        searchRepository.getResult(with: "data", page: "1")
            .assertNoFailure()
            .sink { bookList in
                coreDataManager.verifyFetch(callCount: 1)
                urlSessionManager.verifyPerformDataTask(callCount: 0)
                if bookList.totalPage == "10" {
                    promise.fulfill()
                }

            }
            .store(in: &cancellables)
        
        wait(for: [promise], timeout: 1)
    }
    
    func test_서버_데이터의_total이_0이라면_error를_발생시켜야한다() {
        guard let path = Bundle.main.path(forResource: "BookListInvalidData", ofType: "json"),
              let jsonString = try? String(contentsOfFile: path),
              let data = jsonString.data(using: .utf8) else {
            return
        }

        let urlSessionManager = SpyURLSessionManager(data: data)
        let coreDataManager = SpyCoreDataManager(result: .failure(CoreDataError.invalidData))
        let searchRepository = SearchRepository(urlSessionManager: urlSessionManager, coreDataManager: coreDataManager)
        
        let promise = expectation(
            description: "서버 데이터의 total이 0이라면 error를 발생시켜야한다."
        )
        
        searchRepository.getResult(with: "data", page: "1")
            .sink(receiveCompletion: { error in
                switch error {
                case .failure(_):
                    promise.fulfill()
                case .finished:
                    return
                }
            }, receiveValue: { bookList in
                XCTFail("Should not receive Value")
            })
            .store(in: &cancellables)
        
        wait(for: [promise], timeout: 1)
    }
    
    func test_받아올_전체_result의_수가_123개이면_totalPage는_13이_되어야한다() {
        guard let path = Bundle.main.path(forResource: "BookListDataSecond", ofType: "json"),
              let jsonString = try? String(contentsOfFile: path),
              let data = jsonString.data(using: .utf8) else {
            return
        }

        let urlSessionManager = SpyURLSessionManager(data: data)
        let coreDataManager = SpyCoreDataManager(result: .failure(CoreDataError.invalidData))
        let searchRepository = SearchRepository(urlSessionManager: urlSessionManager, coreDataManager: coreDataManager)
        
        let promise = expectation(
            description: "받아올 전체 result의 수가 123개이면 totalPage는 13이 되어야한다."
        )
        searchRepository.getResult(with: "data", page: "1")
            .assertNoFailure()
            .eraseToAnyPublisher()
            .sink { bookList in
                if bookList.totalPage == "178" {
                    promise.fulfill()
                }
            }
            .store(in: &cancellables)
        
        wait(for: [promise], timeout: 1)
    }
}
