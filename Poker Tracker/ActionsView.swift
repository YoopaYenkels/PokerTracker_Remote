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
        let betAmount = playersList.players[0].spentThisRound
        gameInfo.betsEqualized = true
        
        for i in 0...(playersList.players.count - 1) {
            if (playersList.players[i].spentThisRound != betAmount) {
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
        if (playersList.players[gameInfo.whoseTurn].myRole == PlayerRole.BigBlind && gameInfo.betsEqualized) {
            NewBettingRound()
        }
        
        ApplyRoles()
        dismiss()
    }
    
    func ShowRaise() {
        if ((playersList.players[gameInfo.whoseTurn].money - (gameInfo.highestBet - playersList.players[gameInfo.whoseTurn].spentThisRound) >= gameInfo.minBet)) {
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
        
        UpdateTurn()
        ApplyRoles()
    }
    
    var body: some View {
        NavigationView {
            VStack (spacing: 60) {
                if (gameInfo.highestBet - playersList.players[gameInfo.whoseTurn].spentThisRound == 0) {
                    Button("Check", action: Check)
                } else {
                    Button("Call", action: Call)
                }         
                
                if (showRaise) {
                        Stepper (value: $amountRaised,
                                 in: gameInfo.minBet...playersList.players[gameInfo.whoseTurn].money - (gameInfo.highestBet - playersList.players[gameInfo.whoseTurn].spentThisRound)) {
                                 Text("Raising by $\(amountRaised)")
                        }.padding(.horizontal, 60)             
                } else {
                    Button("Raise", action: ShowRaise)
                }
                Button("Fold", role: .destructive, action: {})
            }
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
                            showRaise.toggle()
                            dismiss()
                        } label: {
                            Text("Confirm")
                                .fontWeight(.bold)
                        }
                    }
                }
            }
        }
        
    }
}
