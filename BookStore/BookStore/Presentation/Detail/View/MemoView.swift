//
//  MemoView.swift
//  BookStore
//
//  Created by Siwon Kim on 2022/10/02.
//

import SwiftUI

struct MemoView: View {
    @Binding var book: Book
    @Binding var isMemoPresented: Bool
    @Binding var saveMemo: Bool
    
    var body: some View {
        VStack {
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
    
    var submitButton: some View {
        Button("save") {
            saveMemo = true
            isMemoPresented = false
        }
        .padding()
        .foregroundColor(.white)
        .font(.system(size: 15, weight: .bold, design: .default))
        .background(.green)
        .cornerRadius(20)
    }
    
    var dismissButton: some View {
        Button("dismiss") {
            isMemoPresented = false
        }
        .padding()
        .foregroundColor(.white)
        .font(.system(size: 15, weight: .bold, design: .default))
        .background(.blue)
        .cornerRadius(20)
    }
}

//struct MemoView_Previews: PreviewProvider {
//    static var previews: some View {
//        MemoView(book: Book(id: UUID(), title: "sd", subtitle: "", isbn13: "", price: "", image: "", url: "", memo: ""), isMemoPresented: true)
//    }
//}
