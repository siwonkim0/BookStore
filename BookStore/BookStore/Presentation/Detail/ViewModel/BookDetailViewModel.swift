//
//  BookDetailViewModel.swift
//  BookStore
//
//  Created by Siwon Kim on 2022/10/01.
//

import Foundation
import Combine

final class BookDetailViewModel: ObservableObject {
    @Published var error: CoreDataError?
    @Published var hasError = false
    @Published var saveMemo: Bool = false
    @Published var isWebViewPresented: Bool = false
    @Published var isComfirmationDialogPresented: Bool = false
    @Published var isMemoPresented: Bool = false
    @Published var bookDetail: BookDetail = BookDetail(title: "", subtitle: "", authors: "", publisher: "", language: "", isbn13: "", bookPages: "", year: "", rating: "", description: "", price: "", imageUrl: "", url: "", pdf: PDF(chapter2: "", chapter5: ""))
    var book: Book
    private var cancellables = Set<AnyCancellable>()
    private let repository: BookDetailRepository

    init(book: Book, repository: BookDetailRepository) {
        self.book = book
        self.repository = repository
        updateMemo()
    }
    
    func getData(with isbn: String) {
        repository.getBookDetails(with: isbn)
            .catch { error in
                return Just(
                    BookDetail(
                        title: "N/A",
                        subtitle: "N/A",
                        authors: "N/A",
                        publisher: "N/A",
                        language: "N/A",
                        isbn13: "N/A",
                        bookPages: "N/A",
                        year: "N/A",
                        rating: "N/A",
                        description: "N/A",
                        price: "N/A",
                        imageUrl: "N/A",
                        url: "N/A",
                        pdf: PDF(
                            chapter2: "N/A",
                            chapter5: "N/A"
                        )))
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] bookDetail in
                guard let self = self else {
                    return
                }
                self.bookDetail = bookDetail
            }
            .store(in: &cancellables)
    }
    
    func updateMemo() {
        $saveMemo
            .sink { [weak self] save in
                guard let self = self else {
                    return
                }
                if save {
                    self.saveBookMemo()
                }
            }.store(in: &self.cancellables)
    }
    
    private func saveBookMemo() {
        self.repository.saveBookMemo(book: self.book)
            .catch { [weak self] error -> AnyPublisher<Book, Never> in
                if let error = error as? CoreDataError, case .failedToUpdate = error {
                    self?.hasError = true
                    self?.error = error
                }
                return Just(
                    Book(id: UUID(), title: "", subtitle: "", isbn13: "", price: "", image: "", url: "", memo: ""))
                .eraseToAnyPublisher()
            }
            .sink { _ in
                //success alert
            }
            .store(in: &self.cancellables)
    }
}
