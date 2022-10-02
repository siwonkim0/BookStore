//
//  InformationView.swift
//  BookStore
//
//  Created by Siwon Kim on 2022/10/02.
//

import SwiftUI

struct InformationView: View {
    var title: String
    var value: String
    var imageName: String
    
    var body: some View {
        VStack(alignment: .center) {
            Text(title)
                .foregroundColor(.gray)
                .padding(.bottom)
            Spacer()
            Image(systemName: imageName)
                .font(.largeTitle)
                .padding(.bottom)
            Spacer()
            Text(value)
                .font(.callout)
                .frame(width: 80, height: 20)
                .minimumScaleFactor(0.5)
        }
        .frame(width: 80, height: 100)
    }
}

struct InformationView_Previews: PreviewProvider {
    static var previews: some View {
        InformationView(title: "", value: "", imageName: "")
    }
}
