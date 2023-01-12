//
//  MainView.swift
//  Poker Tracker
//
//  Created by Leonidas Kalpaxis on 1/9/23.
//

import SwiftUI

enum GameState {
    case blinds, preflop, flop, turn, river
}

enum PlayerRole {
    case Dealer, SmallBlind, BigBlind
}

struct MainView: View {
    @StateObject var playersList: PlayersList = PlayersList()
    
    @State var whoseTurn: Int = 0
    @State var whoIsDealer: Int = 0
    
    @State var potAmount = 0

    var body: some View {
            NavigationStack {
               ZStack {
                    //Color("bgColor1").ignoresSafeArea(.all)
                    VStack {
                        PotView()
                        
                        if playersList.players.isEmpty {
                            Text("(No Players)")
                                .font(.system(size: 30, weight: .regular))
                                .padding(.top, 30)
                        } else {
                            List {
                                ForEach(Array(zip(playersList.players.indices, playersList.players)), id: \.0) { index, player in
                                    PlayerHomeScreenRowView(
                                        player: player,
                                        whoIsDealer: $whoIsDealer,
                                        playerIndex: index,
                                        isDealer: $playersList.players[index].isDealer
                                    )
                                }
                            }
                            .background(.white)
                            .scrollContentBackground(.hidden)
                        }
                        
                        Spacer()
                        
                        Button {
                            // start round
                        } label: {
                            Text("Start New Round")
                                .font(.system(size: 30, weight: .bold))                   
                        }.buttonStyle(.borderedProminent)
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

struct PlayerHomeScreenRowView: View {
    var player: Player

    @Binding var whoIsDealer: Int
    var playerIndex: Int

    @Binding var isDealer: Bool
    
    var body: some View {
        HStack {
            Label(player.name, systemImage: isDealer ? "crown.fill" : "")
                //.font(.system(size: 24, weight: .regular))
               // .foregroundColor(isDealer ? .red : .black)
            Spacer()
            Label("\(player.money)", systemImage: "dollarsign.circle")
                .foregroundColor(.secondary)
        }
        .padding(.horizontal, 30)
        .onAppear(perform: {
            isDealer = (playerIndex == whoIsDealer)
        })
       
    }
}

struct PotView: View {
    var body: some View {
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
