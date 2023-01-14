//
//  MainView.swift
//  Poker Tracker
//
//  Created by Leonidas Kalpaxis on 1/9/23.
//

import SwiftUI

enum GameState : String {
    case blinds, preflop, flop, turn, river
}

enum PlayerRole : Int {
    case Dealer, SmallBlind, BigBlind, None
}

class GameInfo: ObservableObject {
    @Published var whoIsDealer = 0
    @Published var whoseTurn: Int = 3
    
    @Published var potAmount = 0
    
    // change in settings
    @State var minBet = 2
    
    //highest bet in this betting round
    var highestBet = 0
    
    @Published var gameState: GameState = .blinds
    var betsEqualized: Bool = false
    
}

struct MainView: View {
    @EnvironmentObject var playersList: PlayersList
    @EnvironmentObject var gameInfo: GameInfo
    
    func UpdateTurn() {
        if ((gameInfo.whoseTurn + 2) > playersList.players.count) {
            gameInfo.whoseTurn =  0
        } else {
            gameInfo.whoseTurn += 1
        }
    }
    
    func UpdateDealer() {
        if ((gameInfo.whoIsDealer + 2) > playersList.players.count) {
            gameInfo.whoIsDealer = 0;
        } else {
            gameInfo.whoIsDealer += 1
        }
    }
    
    func ApplyRoles() {
        if (playersList.players.count > 1) {
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
                
                playersList.players[i].myTurn = (i == gameInfo.whoseTurn)
            }
            
        }
    }
    
    func NewRound() {
        // must first give pot amount to winning player, then set to 0
        gameInfo.potAmount = 0
        gameInfo.gameState = .blinds
        
        if (playersList.players.count > 1) {
            for i in 0...(playersList.players.count - 1) {
                playersList.players[i].spentThisRound = 0
            }
        }
        
        UpdateDealer()
        UpdateTurn()
        
        ApplyRoles()
    }
    
    func AddBlinds() {
        if (playersList.players.count > 1) {
            for i in 0...(playersList.players.count - 1) {
                switch (playersList.players[i].myRole) {
                case .SmallBlind:
                    playersList.players[i].money -= gameInfo.minBet/2
                    playersList.players[i].spentThisRound += gameInfo.minBet/2
                    gameInfo.potAmount += gameInfo.minBet/2
                case .BigBlind:
                    playersList.players[i].money -= gameInfo.minBet
                    playersList.players[i].spentThisRound += gameInfo.minBet
                    gameInfo.potAmount += gameInfo.minBet
                default: ()
                }
            }
        }
        
        gameInfo.gameState = .preflop
        gameInfo.highestBet = gameInfo.minBet
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.white).ignoresSafeArea()
                VStack {
                    VStack (alignment: .leading) {
                        Text("Round: \(gameInfo.gameState.rawValue)")
                        Text("Min Bet: \(gameInfo.minBet)")
                        Text("Highest Bet: \(gameInfo.highestBet)")
                        Text("Bets Equalized: \(String(gameInfo.betsEqualized))")
                        Text("Whose Turn: \(playersList.players[gameInfo.whoseTurn].name)")
                    }
                    PotView()
                        .padding(.top, 30)
                    PlayersView()
                    BottomBarView(AddBlinds: self.AddBlinds,
                                  NewRound: self.NewRound,
                                  UpdateTurn: self.UpdateTurn,
                                  ApplyRoles: self.ApplyRoles)
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
                        Button {
                            NewRound()
                        } label:{
                            Image(systemName: "digitalcrown.horizontal.arrow.counterclockwise")
                        }
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
