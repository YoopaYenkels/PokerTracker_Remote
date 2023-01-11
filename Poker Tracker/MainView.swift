//
//  MainView.swift
//  Poker Tracker
//
//  Created by Leonidas Kalpaxis on 1/9/23.
//

import SwiftUI

struct MainView: View {
    
    @StateObject var playersList: PlayersList = PlayersList()
    
    var body: some View {
            NavigationView {
                ZStack {
                    Color("bgColor1").ignoresSafeArea(.all)
                    VStack {                  
                        VStack {
                            Text("Pot")
                                .foregroundColor(.white)
                                .font(.system(size: 40, weight: .regular))
                                .frame(width: 300)
                                .padding(.top, 20)
                            Text("$2000")
                                .foregroundColor(.white)
                                .font(.system(size: 40, weight: .light))
                                .frame(width: 300)
                            
                            Image(systemName: "heart.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 34, height: 34)
                                .foregroundColor(.red)
                            
                            HStack {
                                PlayerInfoText(text: "Daki")
                                Spacer()
                                PlayerInfoText(text: "$450")
                            }.padding()
                        }
                        
                        Spacer()
                        
                        HStack (spacing: 20) {
                            ActionButton(text: "Call")
                                .font(.system(size: 30, weight: .bold))
                                .background(.green)
                                .cornerRadius(10)
                            ActionButton(text: "Raise")
                                .font(.system(size: 30, weight: .bold))
                                .background(.blue)
                                .cornerRadius(10)
                            ActionButton(text: "Fold")
                                .font(.system(size: 30, weight: .bold))
                                .background(.red)
                                .cornerRadius(10)
                        }.padding()
                    }
                }
                .navigationTitle("Poker Tracker")
                .toolbar {
                    NavigationLink (destination: PlayerManager(observedPlayersList: playersList)) {

                        Image(systemName: "list.bullet")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 340, height: 24,
                                   alignment: .trailing)
                            .foregroundColor(.white)
                    }
                }
            }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}

struct ActionButton: View {
    var text: String
    
    var body: some View {
        Button(text , action: {})
            .foregroundColor(.white)
            .frame(width: 100, height: 50)
    }
}

struct PlayerInfoText: View {
    var text: String
    
    var body: some View {
        Text(text)
            .foregroundColor(.white)
            .font(.system(size: 34, weight: .regular))
            .padding(.top, 20)
    }
}



