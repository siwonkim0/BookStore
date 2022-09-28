//
//  ScrollToTopButtonView.swift
//  BookStore
//
//  Created by Siwon Kim on 2022/09/28.
//

import SwiftUI

struct ScrollToTopButtonView: View {
    var id: UUID
    var proxy: ScrollViewProxy
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button(action: {
                    withAnimation {
                        proxy.scrollTo(id, anchor: .top)
                    }
                }, label: {
                    Image(systemName: "arrow.up.circle.fill")
                }).padding(.trailing, 20)
                    .font(.largeTitle)
                    .foregroundColor(Color("lightPurple"))
                
            }
        }
    }
}

//struct ScrollToTopButtonView_Previews: PreviewProvider {
//    static var previews: some View {
//        ScrollToTopButtonView()
//    }
//}
