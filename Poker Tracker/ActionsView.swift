//
//  ActionsView.swift
//  Poker Tracker
//
//  Created by Leonidas Kalpaxis on 1/13/23.
//

import Foundation
import SwiftUI

struct PlacedBet {
    var id: UUID
    var name: String
    var amount: Int
}

struct ActionsView: View {
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject var playersList: PlayersList
    @EnvironmentObject var gameInfo: GameInfo
    @EnvironmentObject var potList: PotList
    
    @Binding var showRaise: Bool
    @Binding var amountRaised: Int
    
    @State private var showFoldConfirmation = false
    
    var UpdateTurn: () -> Void
    var ApplyRoles: () -> Void
    var NewBettingRound: () -> Void
    
    
    func CreatePots() {
        var placedBets: [PlacedBet] = []
        
        for i in 0...(playersList.players.count - 1) {
            placedBets.append(PlacedBet(id: playersList.players[i].id,
                                        name: playersList.players[i].name,
                                        amount: playersList.players[i].spentThisRound))
        }
        
        placedBets.sort {$0.amount < $1.amount}
        print(placedBets)
        //        if (playersList.players[i].allIn == true &&
        //            playersList.players[i].spentThisRound > 0) {
        //
        //            let remaining = (potList.totalBets - playersList.players[i].spentThisRound * gameInfo.numActivePlayers)
        //
        //            potList.pots[potList.currentPot].money = playersList.players[i].spentThisRound * gameInfo.numActivePlayers
        //
        //            potList.currentPot += 1
        //            potList.pots.append(Pot(name: "Side Pot \(potList.currentPot)", money: remaining))
        //        }
        
    }
    
    func CheckEqualBets() {
        gameInfo.betsEqualized = true
        
        for i in 0...(playersList.players.count - 1) {
            if (!playersList.players[i].hasFolded &&
                ((playersList.players[i].spentThisRound != gameInfo.highestBet && !playersList.players[i].allIn) ||
                 (playersList.players[i].spentThisRound == 0 && !playersList.players[i].allIn) ||
                 !playersList.players[i].hasPlayed)) {
                gameInfo.betsEqualized = false
                break
            }
        }
        
        if (gameInfo.betsEqualized ||
            gameInfo.numChecks == gameInfo.numActivePlayers) {
            CreatePots()
            NewBettingRound()
            ApplyRoles()
            dismiss()
        }
        else {
            UpdateTurn()
            ApplyRoles()
            dismiss()
        }
    }
    
    func Call() {
        var amountToCall = 0
        
        if ((gameInfo.highestBet - playersList.players[gameInfo.whoseTurn].spentThisRound)
            <= playersList.players[gameInfo.whoseTurn].money) {
            amountToCall = gameInfo.highestBet - playersList.players[gameInfo.whoseTurn].spentThisRound
        }
        else {
            amountToCall = playersList.players[gameInfo.whoseTurn].money
            playersList.players[gameInfo.whoseTurn].allIn = true
        }
        
        playersList.players[gameInfo.whoseTurn].money -= amountToCall
        playersList.players[gameInfo.whoseTurn].spentThisRound += amountToCall
        potList.totalBets += amountToCall
        
        playersList.players[gameInfo.whoseTurn].hasPlayed = true
        showRaise = false
        CheckEqualBets()
    }
    
    func Check() {
        playersList.players[gameInfo.whoseTurn].hasPlayed = true
        gameInfo.numChecks += 1
        showRaise = false
        CheckEqualBets()
    }
    
    func ShowRaise() {
        if ((gameInfo.minBet <= playersList.players[gameInfo.whoseTurn].money - gameInfo.highestBet)
            && (gameInfo.numRaises < 3 ||
                playersList.players.count == 2)) {
            showRaise = true
        }
        amountRaised = gameInfo.minBet
    }
    
    func SubmitRaise() {
        let amountToCall = (gameInfo.highestBet - playersList.players[gameInfo.whoseTurn].spentThisRound)
        
        if (amountToCall + amountRaised > playersList.players[gameInfo.whoseTurn].money) {
            playersList.players[gameInfo.whoseTurn].allIn = true
        }
        
        playersList.players[gameInfo.whoseTurn].spentThisRound += amountToCall + amountRaised
        playersList.players[gameInfo.whoseTurn].money -= amountToCall + amountRaised
        potList.totalBets += amountToCall + amountRaised
        
        gameInfo.highestBet = playersList.players[gameInfo.whoseTurn].spentThisRound
        gameInfo.numRaises += 1
        
        playersList.players[gameInfo.whoseTurn].hasPlayed = true
        showRaise = false
        
        UpdateTurn()
        ApplyRoles()
        
        dismiss()
    }
    
    func Fold() {
        showRaise = false
        playersList.players[gameInfo.whoseTurn].hasPlayed = true
        playersList.players[gameInfo.whoseTurn].hasFolded = true
        gameInfo.numActivePlayers -= 1
        
        CheckEqualBets()
    }
    
    var body: some View {
        NavigationView {
            VStack (alignment: .leading, spacing: 30) {
                VStack (spacing: 20) {
                    MoneyStatusView(text: "Current",
                                    image1: "arrow.up.circle",
                                    image2: "dollarsign.circle",
                                    moneySpent: playersList.players[gameInfo.whoseTurn].spentThisRound,
                                    totalMoney: playersList.players[gameInfo.whoseTurn].money)
                    //                    MoneyStatusView(text: "Call",
                    //                                    image1: "arrow.up.circle",
                    //                                    image2: "dollarsign.circle",
                    //                                    moneySpent: gameInfo.highestBet - playersList.players[gameInfo.whoseTurn].spentThisRound,
                    //                                    totalMoney: playersList.players[gameInfo.whoseTurn].money - (gameInfo.highestBet - playersList.players[gameInfo.whoseTurn].spentThisRound))
                    //                    if (showRaise) {
                    //                        MoneyStatusView(text: "Raise",
                    //                                        image1: "arrow.up.circle",
                    //                                        image2: "dollarsign.circle",
                    //                                        moneySpent: (gameInfo.highestBet - playersList.players[gameInfo.whoseTurn].spentThisRound) + amountRaised,
                    //                                        totalMoney: playersList.players[gameInfo.whoseTurn].money - (gameInfo.highestBet - playersList.players[gameInfo.whoseTurn].spentThisRound) - amountRaised)
                    //                    }
                }
                
                Spacer()
                
                if ((gameInfo.highestBet - playersList.players[gameInfo.whoseTurn].spentThisRound == 0) ||
                    playersList.players[gameInfo.whoseTurn].allIn) {
                    Button {
                        Check()
                    } label: {
                        HStack{
                            Text("Check")
                            Spacer()
                            Image(systemName: "checkmark")
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(Color.green)
                } else if (!playersList.players[gameInfo.whoseTurn].allIn &&
                           playersList.players[gameInfo.whoseTurn].money > 0) {
                    Button {
                        Call()
                    } label: {
                        HStack{
                            Text("Call")
                            Spacer()
                            Image(systemName: "dollarsign.circle")
                            (gameInfo.highestBet - playersList.players[gameInfo.whoseTurn].spentThisRound)
                            < playersList.players[gameInfo.whoseTurn].money ? Text("\(gameInfo.highestBet - playersList.players[gameInfo.whoseTurn].spentThisRound)") : Text(" \(playersList.players[gameInfo.whoseTurn].money) (ALL IN)")
                        }
                    }.buttonStyle(.borderedProminent)
                }
                
                if (showRaise) {
                    HStack {
                        Button {
                            SubmitRaise()
                        } label: {
                            HStack{
                                Text("Raise")
                                Spacer()
                                (gameInfo.highestBet - playersList.players[gameInfo.whoseTurn].spentThisRound + amountRaised) == playersList.players[gameInfo.whoseTurn].money ?
                                Text("ALL IN") :
                                Text("\(gameInfo.highestBet - playersList.players[gameInfo.whoseTurn].spentThisRound) + $\(amountRaised)")
                            }
                        }
                        .buttonStyle(.bordered)
                        
                        Stepper (value: $amountRaised,
                                 in: gameInfo.minBet...(playersList.players[gameInfo.whoseTurn].money
                                                        - (gameInfo.highestBet - playersList.players[gameInfo.whoseTurn].spentThisRound))) {}
                        
                    }
                }
                
                Button (role: .destructive) {
                    showFoldConfirmation = true
                } label: {
                    HStack{
                        Text("Fold")
                        Spacer()
                        Image(systemName: "x.circle")
                    }
                }
                .buttonStyle(.bordered)
                .confirmationDialog("Confirm Fold", isPresented: $showFoldConfirmation) {
                    Button ("Fold", role: .destructive) {
                        Fold()
                    }
                } message: {
                    Text("Are you sure?")
                }
            }
            .padding(.horizontal, 20)
            .onAppear(perform: ShowRaise)
            .navigationTitle("\(playersList.players[gameInfo.whoseTurn].name)'s Actions")
            .toolbar {
                ToolbarItem (placement: .navigationBarLeading) {
                    Button("Cancel") {
                        showRaise = false
                        dismiss()
                    }
                }
                
            }
        }
    }
    
    struct MoneyStatusView: View {
        var text: String
        var image1: String
        var image2: String
        
        var moneySpent: Int
        var totalMoney: Int
        
        var body: some View {
            HStack {
                Text(text)
                Spacer()
                Image(systemName: image1)
                Text("\(moneySpent)")
                
                HStack {
                    Image(systemName: image2)
                    Text("\(totalMoney)")
                }
                .foregroundColor(.secondary)
            }
        }
    }
}
