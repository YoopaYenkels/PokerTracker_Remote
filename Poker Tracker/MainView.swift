//
//  MainView.swift
//  Poker Tracker
//
//  Created by Leonidas Kalpaxis on 1/9/23.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        
        ZStack {
            Color.green.ignoresSafeArea(.all)
            
            VStack {
                HStack {
                    Text("Poker Tracker")
                        .foregroundColor(.white)
                        .font(.system(size: 40, weight: .bold))
                        .frame(width: 300, alignment: .leading)
                        .padding(.vertical, 20)
                    
                     Image(systemName: "gearshape.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 34, height: 34)
                        .foregroundColor(.white)
                
                    
                }
                
                Spacer()
                
                Image(systemName: "heart.fill")
                    .imageScale(.large)
                    .foregroundColor(.red)
                    .padding()
               
            }
            
           
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
