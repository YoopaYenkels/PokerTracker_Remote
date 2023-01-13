//
//  PotView.swift
//  Poker Tracker
//
//  Created by Leonidas Kalpaxis on 1/12/23.
//

import Foundation
import SwiftUI

struct PotView: View {
    var body: some View {
        VStack {
            Divider()
                .frame(width: 300, height: 4)
                .overlay(.black)
              
            HStack (spacing: 20){
                Image(systemName: "suit.club.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 34, height: 34)
                
                Image(systemName: "suit.heart.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 34, height: 34)
                    .foregroundColor(.red)
                    
                
                Image(systemName: "suit.spade.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 34, height: 34)
                    
                
                Image(systemName: "suit.diamond.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 34, height: 34)
                    .foregroundColor(.red)
            }
            Divider()
                .frame(width: 300, height: 4)
                .overlay(.black)
            
            Text("Pot")
                .font(.system(size: 40, weight: .regular))

            Text("$0")
                .font(.system(size: 40, weight: .light))
            
            Divider()
                .frame(width: 300, height: 4)
                .overlay(.black)
         
        }.padding(.top, 50)
    }
}
