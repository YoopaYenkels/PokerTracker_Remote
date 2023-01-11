//
//  MainView.swift
//  Poker Tracker
//
//  Created by Leonidas Kalpaxis on 1/9/23.
//

import SwiftUI

struct MainView: View {
    
    @StateObject var playersList: PlayersList = PlayersList()
    @State var potAmount = 0
    
    var body: some View {
            NavigationStack {
                ZStack {
                    //Color("bgColor1").ignoresSafeArea(.all)
                    VStack {                  
                        VStack {
                            Text("Pot")
                                .font(.system(size: 40, weight: .regular))
    
                            Text("$2000")
                                .font(.system(size: 40, weight: .light))
                            
                            Image(systemName: "heart.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 34, height: 34)
                                .foregroundColor(.red)
                            
                            HStack {
                                PlayerInfoText(text: "Daki")
                                Spacer()
                                PlayerInfoText(text: "$450")
                            }.padding(.horizontal, 60)
                            
                        }
                        
                        
                        
//                        HStack (spacing: 20) {
//                            ActionButton(text: "Call")
//                                .font(.system(size: 30, weight: .bold))
//                                .background(Color("bgColor1"))
//                                .cornerRadius(10)
//                            ActionButton(text: "Raise")
//                                .font(.system(size: 30, weight: .bold))
//                                .background(.blue)
//                                .cornerRadius(10)
//                            ActionButton(text: "Fold")
//                                .font(.system(size: 30, weight: .bold))
//                                .background(.red)
//                                .cornerRadius(10)
//                        }.padding()
                    }
                }
                .navigationTitle("Poker Tracker")
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading){
                        NavigationLink (destination: PlayerManager(observedPlayersList: playersList)) {

                            Image(systemName: "person.badge.plus")
                                .imageScale(.large)
                        }
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
            .font(.system(size: 34, weight: .regular))
            .padding(.top, 20)
    }
}



