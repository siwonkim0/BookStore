//
//  MemoView.swift
//  BookStore
//
//  Created by Siwon Kim on 2022/10/02.
//

import SwiftUI

struct MemoView: View {
    @EnvironmentObject var book: Book
    @Binding var isMemoPresented: Bool
    
    var body: some View {
        VStack {
            descriptionView
            textEditorView
            HStack {
                submitButton
                dismissButton
            }
        }.padding()
    }
}

extension MemoView {
    var textEditorView: some View {
        TextEditor(text: $book.memo)
            .frame(height: 250)
            .padding(.all, .maximum(5, 5))
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(.gray))
    }
    
    var descriptionView: some View {
        Text("you can take memo here")
    }
    
    var submitButton: some View {
        Button("save") {
            print("aaaa")
        }
        .foregroundColor(.white)
        .font(.headline)
        .padding()
        .background(Color.green.cornerRadius(10))
    }
    
    var dismissButton: some View {
        Button("dismiss") {
            isMemoPresented = false
        }
        .foregroundColor(.white)
        .font(.headline)
        .padding()
        .background(Color.red.cornerRadius(10))
    }
}

struct MemoView_Previews: PreviewProvider {
    static var previews: some View {
        MemoView(isMemoPresented: .constant(true))
            .environmentObject(Book(id: UUID(), title: "sd", subtitle: "", isbn13: "", price: "", image: "", url: "", memo: ""))
    }
}
