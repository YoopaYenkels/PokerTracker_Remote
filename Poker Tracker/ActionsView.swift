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
                 playersList.players[i].hasPlayed == false)) {
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
        
        if ((gameInfo.betState == .preflop &&
             playersList.players[gameInfo.whoseTurn].myRole == PlayerRole.BigBlind &&
             gameInfo.betsEqualized) ||
            
            (gameInfo.betState == .regular &&
             gameInfo.numChecks == gameInfo.numActivePlayers)) {
            NewBettingRound()
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
            VStack (spacing: 30) {
                HStack {
                    HStack {
                        Image(systemName: "arrow.up.circle")
                        Text("\(playersList.players[gameInfo.whoseTurn].spentThisRound)")
                    }
                    .padding(.trailing, 10)
                    
                    HStack {
                        Image(systemName: "dollarsign.circle")
                        Text("\(playersList.players[gameInfo.whoseTurn].money)")
                    }
                    .foregroundColor(.secondary)
                }
                
                Spacer()
                
                if (gameInfo.highestBet - playersList.players[gameInfo.whoseTurn].spentThisRound == 0) {
                    Button("Check", action: Check)
                } else {
                    Button("Call", action: Call)
                }
                
                if (showRaise) {
                    HStack {
                        Text("Raise by $\(amountRaised)")
                        Stepper (value: $amountRaised,
                                 in: gameInfo.minBet...playersList.players[gameInfo.whoseTurn].money - (gameInfo.highestBet - playersList.players[gameInfo.whoseTurn].spentThisRound)) {
                        }
                    }.padding(.horizontal, 80)
                }
                Button("Fold", role: .destructive, action: Fold)
            }
            .onAppear(perform: ShowRaise)
            .navigationTitle("\(playersList.players[gameInfo.whoseTurn].name)'s Actions")
            .toolbar {
                ToolbarItem (placement: .navigationBarLeading) {
                    Button("Cancel") {
                        showRaise = false
                        dismiss()
                    }
                }
                
                if (showRaise) {
                    ToolbarItem (placement: .navigationBarTrailing) {
                        Button {
                            SubmitRaise()
                        } label: {
                            Text("Raise")
                                .fontWeight(.bold)
                        }
                    }
                }
            }
        }
        
    }
}
