//
//  BookDetailView.swift
//  BookStore
//
//  Created by Siwon Kim on 2022/09/22.
//

import SwiftUI

struct BookDetailView: View {
    @State private var isWebViewPresented: Bool = false
    @Binding var isMemo: Bool
    @State private var memoText: String = "sds"
    
    var body: some View {
        ScrollView {
            VStack {
                imageView
                titleView
                Text("Our NGINX Real-Time API Handbook equips enterprises to deliver reliable, high-performance APIs")
                Text("isbn: 1001650120608")
                Text("price: $13.99")

                Button("link") {
                    isWebViewPresented = true
                }
                .sheet(isPresented: $isWebViewPresented) { //모달창이 내려가면 자동으로 false
                    WebView(url: URL(string: "https://itbook.store/books/9781849517744")!)
                }
                descriptionView
                textEditorView
                submitButton
            }
            .padding(.all)
        }
        
    }
}

private extension BookDetailView {
    var imageView: some View {
        Image(systemName: "character.book.closed.fill")
            .resizable()
            .frame(width: 150, height: 200, alignment: .center)
            .foregroundColor(.cyan)
            .padding(.bottom)
    }
    
    var titleView: some View {
        Text("The NGINX Real-Time API Handbook")
            .font(.title.bold())
            .padding(.bottom)
    }
    
    var textEditorView: some View {
        TextEditor(text: $memoText)
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
    }
}

struct BookDetailView_Previews: PreviewProvider {
    static var previews: some View {
        BookDetailView(isMemo: .constant(true))
    }
}
