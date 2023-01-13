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

enum PlayerRole : Int {
    case Dealer, SmallBlind, BigBlind, None
}

class GameInfo: ObservableObject {
    @Published var whoIsDealer = 0

    @Published var potAmount = 0
    
    @State var minBet = 2
    
    @Published var gameState: GameState = .blinds
//    @Published var whoseTurn: Int = 0
//    @Published var gameState: GameState = .preflop

}

struct MainView: View {
    @EnvironmentObject var playersList: PlayersList
    @EnvironmentObject var gameInfo: GameInfo

    func UpdateDealer() {
        if ((gameInfo.whoIsDealer + 2) > playersList.players.count) {
            gameInfo.whoIsDealer = 0;
        } else {
            gameInfo.whoIsDealer += 1
        }
    }
    
    func ApplyRoles() {
        for i in 0...(playersList.players.count - 1) {
            switch (i - gameInfo.whoIsDealer) {
            case (0): playersList.players[i].myRole = .Dealer
            case (1): playersList.players[i].myRole = .SmallBlind
            case (2): playersList.players[i].myRole = .BigBlind
            default: playersList.players[i].myRole = .None
            }
            
            if (gameInfo.whoIsDealer == (playersList.players.count - 1)) {
                if (i == 0) {
                    playersList.players[i].myRole = .SmallBlind
                } else if (i == 1) {
                    playersList.players[i].myRole = .BigBlind
                }
            } else if (gameInfo.whoIsDealer == (playersList.players.count - 2)) {
                if (i == 0) {
                    playersList.players[i].myRole = .BigBlind
                }
            }       
        }
    }

    
    func NewRound() {
        // must first give pot amount to winning player, then set to 0
        gameInfo.potAmount = 0
        gameInfo.gameState = .blinds
        
        UpdateDealer()
        ApplyRoles()
    }
    
    func AddBlinds() {
        for i in 0...(playersList.players.count - 1) {
            switch (playersList.players[i].myRole) {
            case .SmallBlind:
                playersList.players[i].money -= gameInfo.minBet/2
                gameInfo.potAmount += gameInfo.minBet/2
            case .BigBlind:
                playersList.players[i].money -= gameInfo.minBet
                gameInfo.potAmount += gameInfo.minBet
            default: ()
            }
        }
        
        gameInfo.gameState = .preflop
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.white).ignoresSafeArea()
                VStack {
                    PotView()
                    PlayersView()
                    Spacer()
                    
                    HStack {
                        if (gameInfo.gameState == .blinds) {
                            Button ("Begin Round", action: AddBlinds)
                                .buttonStyle(.borderedProminent)
                        } else if (gameInfo.gameState == .preflop) {
                            Button ("New Round", action: NewRound)
                                .buttonStyle(.bordered)
                        }
                    }
                }
                .navigationTitle("Poker Tracker")
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading){
                        NavigationLink (destination: PlayerManager()) {
                            Image(systemName: "person.badge.plus")
                                .imageScale(.large)
                        }
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing){
                        Image(systemName: "gear")
                            .imageScale(.large)
                    }
                }
                .onAppear(perform: ApplyRoles)
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environmentObject(GameInfo())
            .environmentObject(PlayersList())
    }
}
