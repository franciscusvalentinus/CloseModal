//
//  PageSatu.swift
//  CloseModal
//
//  Created by Franciscus Valentinus Ongkosianbhadra on 30/10/22.
//

import SwiftUI

struct PageSatu: View {
    @State var isOpenPageDua = false
    var body: some View {
        NavigationView{
            VStack{
                Text("satu")
                Button {
                    isOpenPageDua = true
                } label: {
                    Text("Ke Page Dua")
                }
                
                NavigationLink(destination: PageDua(tempatNerimaDariPageLain: $isOpenPageDua) , isActive: $isOpenPageDua){
                    EmptyView()
                }
            }
        }
    }
}

struct PageSatu_Previews: PreviewProvider {
    static var previews: some View {
        PageSatu()
    }
}
