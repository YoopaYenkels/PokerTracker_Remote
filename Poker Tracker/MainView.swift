//
//  MainView.swift
//  Poker Tracker
//
//  Created by Leonidas Kalpaxis on 1/9/23.
//

import SwiftUI

enum BetState : String {
    case blinds, preflop, regular
}

enum PlayerRole : Int {
    case Dealer, SmallBlind, BigBlind, None
}

class GameInfo: ObservableObject {
    @Published var whoIsDealer = 0
    @Published var whoseTurn: Int = 3
    var sbPos: Int = 1
    
    var potGiven = false
    
    // change in settings
    @State var minBet = 2
    
    //highest bet in this betting round
    var highestBet = 0
    
    @Published var betState: BetState = .blinds
    var betsEqualized: Bool = false
    var bettingRound: Int = 0
    
    var numRaises: Int = 0
    var numChecks: Int = 0
    var numActivePlayers: Int = 0
    
}

struct MainView: View {
    @EnvironmentObject var playersList: PlayersList
    @EnvironmentObject var gameInfo: GameInfo
    @EnvironmentObject var potList: PotList
    
    func UpdateTurn() {
        let upper = (playersList.players.count - 1) - gameInfo.whoseTurn
        
        if (gameInfo.whoseTurn < playersList.players.count - 1) {
            for i in (1...upper) {
                if (!playersList.players[gameInfo.whoseTurn + i].hasFolded)  {
                    gameInfo.whoseTurn = gameInfo.whoseTurn + i
                    playersList.players[gameInfo.whoseTurn].myTurn = true
                    return
                }
            }
        }
        
        for i in (0...playersList.players.count) {
            if (!playersList.players[i].hasFolded)  {
                gameInfo.whoseTurn = i
                playersList.players[i].myTurn = true
                return
            }
        }
    }
    
    func UpdateDealer() {
        if ((gameInfo.whoIsDealer + 2) > playersList.players.count) {
            gameInfo.whoIsDealer = 0;
        } else {
            gameInfo.whoIsDealer += 1
        }
    }
    
    func NewBettingRound() {
        if (gameInfo.betState == .preflop) {gameInfo.betState = .regular}
        
        gameInfo.bettingRound += 1
        gameInfo.numChecks = 0
        gameInfo.numRaises = 0
        gameInfo.highestBet = 0
        gameInfo.betsEqualized = false
        
        potList.totalBets = 0
        
        for i in 0...(playersList.players.count - 1) {
            playersList.players[i].spentThisRound = 0
            
            if (!playersList.players[i].hasFolded) {
                playersList.players[i].hasPlayed = false
            }
        }
        
        
        if (!playersList.players[gameInfo.sbPos].hasFolded) {
            gameInfo.whoseTurn = gameInfo.sbPos
            return
        }
        
        let upper = (playersList.players.count - 1) - gameInfo.sbPos
        
        if (gameInfo.sbPos < playersList.players.count - 1) {
            for i in (1...upper) {
                if (!playersList.players[gameInfo.sbPos + i].hasFolded)  {
                    gameInfo.sbPos += i
                    gameInfo.whoseTurn = gameInfo.sbPos
                    return  
                }
            }
        }
        
        for i in (0...playersList.players.count) {
            if (!playersList.players[i].hasFolded)  {
                gameInfo.sbPos = i
                gameInfo.whoseTurn = gameInfo.sbPos
                return
            }
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
    
    func NewHand() {
        gameInfo.potGiven = false
        gameInfo.betState = .blinds
        gameInfo.bettingRound = 0
        gameInfo.betsEqualized = false
        gameInfo.numActivePlayers = playersList.players.count
        
        potList.currentPot = 0
        
        if (playersList.players.count > 1) {
            for i in 0...(playersList.players.count - 1) {
                playersList.players[i].spentThisRound = 0
                playersList.players[i].hasFolded = false
            }
        }
        
        if (gameInfo.whoIsDealer < playersList.players.count - 3) {
            gameInfo.whoseTurn = gameInfo.whoIsDealer + 3
        } else {
            gameInfo.whoseTurn = abs(playersList.players.count - gameInfo.whoIsDealer - 3)
        }
        
        if (gameInfo.whoIsDealer < playersList.players.count - 1) {
            gameInfo.sbPos = gameInfo.whoIsDealer + 1
        } else {
            gameInfo.sbPos = abs(playersList.players.count - gameInfo.whoIsDealer - 1)
        }
        
        ApplyRoles()
    }
    
    func AddBlinds() {
        if (playersList.players.count > 1) {
            for i in 0...(playersList.players.count - 1) {
                switch (playersList.players[i].myRole) {
                case .SmallBlind:
                    playersList.players[i].money -= gameInfo.minBet/2
                    playersList.players[i].spentThisRound += gameInfo.minBet/2
                    potList.totalBets += gameInfo.minBet/2
                case .BigBlind:
                    playersList.players[i].money -= gameInfo.minBet
                    playersList.players[i].spentThisRound += gameInfo.minBet
                    potList.totalBets += gameInfo.minBet
                default: ()
                }
            }
        }
        
        gameInfo.betState = .preflop
        gameInfo.highestBet = gameInfo.minBet
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.white).ignoresSafeArea()
                VStack {
                    VStack (alignment: .leading) {
                        
                        Text("Num Checks: \(gameInfo.numChecks)")
                        Text("Highest Bet: \(gameInfo.highestBet)")
                        Text("current Pot: \(potList.currentPot)")
                        Text("Total Bets: \(potList.totalBets)")
                        //                        Text("Whose Turn: \(playersList.players[gameInfo.whoseTurn].name)  \(gameInfo.whoseTurn)")
                        //                        Text("Active Players: \(gameInfo.numActivePlayers)")
                    }
                    PotView()
                    
                    Text("Round: \(gameInfo.betState.rawValue) \(gameInfo.bettingRound)")
                    
                    Text("Num Raises: \(gameInfo.numRaises)")
                    
                    PlayersView()
                    Divider()
                    BottomBarView(AddBlinds: self.AddBlinds,
                                  NewHand: self.NewHand,
                                  UpdateTurn: self.UpdateTurn,
                                  ApplyRoles: self.ApplyRoles,
                                  NewBettingRound: self.NewBettingRound)
                }
                .navigationTitle("Poker Tracker")
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading){
                        NavigationLink (destination: PlayerManager()) {
                            Image(systemName: "person.badge.plus")
                                .imageScale(.large)
                        }
                    }
                    
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            UpdateDealer()
                            NewHand()
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
            .environmentObject(PotList())
    }
}
