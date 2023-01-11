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
                PotView()
                
                
                
                if playersList.players.isEmpty {
                    Text("(No Players)")
                        .font(.system(size: 30, weight: .regular))
                        .padding(.top, 30)
                } else {
                    List {
                        ForEach(playersList.players) {player in
                            PlayerHomeScreenView(player: player)
                        }
                    }
                    .background(.white)
                    .scrollContentBackground(.hidden)
                }
                
                Spacer()
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
            
            ToolbarItem(placement: .navigationBarTrailing){
                NavigationLink (destination: {}) {
                    Image(systemName: "gear")
                        .imageScale(.large)
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

struct PlayerHomeScreenView: View {
    var player: Player
    
    var body: some View {
        HStack {
            Text(player.name)
                .font(.system(size: 24, weight: .regular))

            Spacer()
            Label("\(player.money)", systemImage: "dollarsign.circle")
        }.padding(.horizontal, 30)
    }
}


struct PotView: View {
    var body: some View {
        VStack {
            VStack {
                Divider()
                    .frame(width: 300, height: 4)
                    .overlay(.black)
                Text("Pot")
                    .font(.system(size: 40, weight: .regular))
                
                Text("$0")
                    .font(.system(size: 40, weight: .light))
                
                Image(systemName: "heart.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 34, height: 34)
                    .foregroundColor(.red)
                    .padding(.bottom, 30)
                Divider()
                    .frame(width: 300, height: 4)
                    .overlay(.black)
            }.padding(.top, 50)
        }
    }
    
}
//struct ActionsView: View {
//    var body: some View {
//        HStack (spacing: 20) {
//            ActionButton(text: "Call")
//                .font(.system(size: 30, weight: .bold))
//                .background(Color("bgColor1"))
//                .cornerRadius(10)
//            ActionButton(text: "Raise")
//                .font(.system(size: 30, weight: .bold))
//                .background(.blue)
//                .cornerRadius(10)
//            ActionButton(text: "Fold")
//                .font(.system(size: 30, weight: .bold))
//                .background(.red)
//                .cornerRadius(10)
//        }.padding()
//    }
//}
