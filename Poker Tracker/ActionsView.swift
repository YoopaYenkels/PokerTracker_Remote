//
//  ActionsView.swift
//  Poker Tracker
//
//  Created by Leonidas Kalpaxis on 1/13/23.
//

import Foundation
import SwiftUI

struct ActionsView: View {
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject var playersList: PlayersList
    @EnvironmentObject var gameInfo: GameInfo
    
    @Binding var showRaise: Bool
    @Binding var amountRaised: Int
    
    var UpdateTurn: () -> Void
    var ApplyRoles: () -> Void
    var NewBettingRound: () -> Void
    
    func CheckEqualBets() {
        gameInfo.betsEqualized = true
        
        for i in 0...(playersList.players.count - 1) {
            if (!playersList.players[i].hasFolded &&
                (playersList.players[i].spentThisRound != gameInfo.highestBet ||
                 playersList.players[i].spentThisRound == 0 ||
                 !playersList.players[i].hasPlayed)) {
                gameInfo.betsEqualized = false
                return
            }
        }
    }
    
    func Call() {
        let amountToCall = (gameInfo.highestBet - playersList.players[gameInfo.whoseTurn].spentThisRound)
        
        playersList.players[gameInfo.whoseTurn].money -= amountToCall
        playersList.players[gameInfo.whoseTurn].spentThisRound += amountToCall
        gameInfo.potAmount += amountToCall
        
        playersList.players[gameInfo.whoseTurn].hasPlayed = true
        
        CheckEqualBets()
        
        if (gameInfo.betsEqualized) {
            NewBettingRound()
            ApplyRoles()
            return
        }
        
        UpdateTurn()
        ApplyRoles()
        dismiss()
    }
    
    func Check() {
        playersList.players[gameInfo.whoseTurn].hasPlayed = true
        gameInfo.numChecks += 1
        
        CheckEqualBets()
        
        if (gameInfo.betsEqualized ||
            (gameInfo.betState == .regular &&
             gameInfo.numChecks == gameInfo.numActivePlayers)) {
            NewBettingRound()
            ApplyRoles()
            return
        }
        
        UpdateTurn()
        ApplyRoles()
        dismiss()
    }
    
    func ShowRaise() {
        if (gameInfo.minBet <= (playersList.players[gameInfo.whoseTurn].money - (gameInfo.highestBet - playersList.players[gameInfo.whoseTurn].spentThisRound))) {
            showRaise = true
        }
        amountRaised = gameInfo.minBet
    }
    
    func SubmitRaise() {
        let amountToCall = (gameInfo.highestBet - playersList.players[gameInfo.whoseTurn].spentThisRound)
        
        playersList.players[gameInfo.whoseTurn].spentThisRound += amountToCall + amountRaised
        playersList.players[gameInfo.whoseTurn].money -= amountToCall + amountRaised
        gameInfo.potAmount += amountToCall + amountRaised
        
        gameInfo.highestBet = playersList.players[gameInfo.whoseTurn].spentThisRound
        
        playersList.players[gameInfo.whoseTurn].hasPlayed = true
        
        UpdateTurn()
        ApplyRoles()
        
        showRaise = false
        dismiss()
    }
    
    func Fold() {
        playersList.players[gameInfo.whoseTurn].hasPlayed = true
        playersList.players[gameInfo.whoseTurn].hasFolded = true
        gameInfo.numActivePlayers -= 1
        
        CheckEqualBets()
        
        if (gameInfo.betsEqualized) {
            NewBettingRound()
            ApplyRoles()
            return
        }
        
        UpdateTurn()
        ApplyRoles()
        dismiss()
    }
    
    var body: some View {
        NavigationView {
            VStack (alignment: .leading, spacing: 30) {
                VStack {
                    MoneyStatusView(text: "Current",
                                    image1: "arrow.up.circle",
                                    image2: "dollarsign.cirle",
                                    moneySpent: playersList.players[gameInfo.whoseTurn].spentThisRound,
                                    totalMoney: playersList.players[gameInfo.whoseTurn].money)
                    MoneyStatusView(text: "Call",
                                    image1: "arrow.up.circle",
                                    image2: "dollarsign.cirle",
                                    moneySpent: playersList.players[gameInfo.whoseTurn].spentThisRound + gameInfo.highestBet - playersList.players[gameInfo.whoseTurn].spentThisRound,
                                    totalMoney: playersList.players[gameInfo.whoseTurn].money - gameInfo.highestBet - playersList.players[gameInfo.whoseTurn].spentThisRound)
                    MoneyStatusView(text: "Raise",
                                    image1: "arrow.up.circle",
                                    image2: "dollarsign.cirle",
                                    moneySpent: playersList.players[gameInfo.whoseTurn].spentThisRound + amountRaised,
                                    totalMoney: playersList.players[gameInfo.whoseTurn].money - amountRaised)
                        
                }
                
                
                Spacer()
                
                if (gameInfo.highestBet - playersList.players[gameInfo.whoseTurn].spentThisRound == 0) {
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
                } else {
                    Button {
                        Call()
                    } label: {
                        HStack{
                            Text("Call")
                            Spacer()
                            Image(systemName: "dollarsign.circle")
                            Text("\(gameInfo.highestBet - playersList.players[gameInfo.whoseTurn].spentThisRound)")
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
                                Text("\(gameInfo.highestBet - playersList.players[gameInfo.whoseTurn].spentThisRound) + $\(amountRaised)")
                            }
                        }
                        .buttonStyle(.bordered)
                        Stepper (value: $amountRaised,
                                 in: gameInfo.minBet...playersList.players[gameInfo.whoseTurn].money - (gameInfo.highestBet - playersList.players[gameInfo.whoseTurn].spentThisRound)) {}
                    }
                }
                
                Button (role: .destructive) {
                    Fold()
                } label: {
                    HStack{
                        Text("Fold")
                        Spacer()
                        Image(systemName: "x.circle")
                    }
                }.buttonStyle(.bordered)
            }
            .padding(.horizontal, 16)
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

