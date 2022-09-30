//
//  BookDetailView.swift
//  BookStore
//
//  Created by Siwon Kim on 2022/09/22.
//

import SwiftUI

struct BookDetailView: View {
    @State private var isPresented: Bool = false
    @Binding var isMemo: Bool
    
    var body: some View {
        ScrollView {
            VStack {
                Image(systemName: "character.book.closed.fill")
                    .resizable()
                    .frame(width: 150, height: 200, alignment: .center)
                    .foregroundColor(.cyan)
                    .padding(.bottom)
                Text("The NGINX Real-Time API Handbook")
                    .font(.title.bold())
                    .padding(.bottom)
                Text("Our NGINX Real-Time API Handbook equips enterprises to deliver reliable, high-performance APIs")
                Text("isbn: 1001650120608")
                Text("price: $13.99")
                Button("link") {
                    isPresented = true
                }
                .sheet(isPresented: $isPresented) { //모달창이 내려가면 자동으로 false
                    WebView(url: URL(string: "https://itbook.store/books/9781849517744")!)
                }
            }
            .padding(.all)
            .frame(alignment: .leading)
        }
        
    }
}

struct BookDetailView_Previews: PreviewProvider {
    static var previews: some View {
        BookDetailView(isMemo: .constant(true))
    }
}
