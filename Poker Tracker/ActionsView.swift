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
    
    var UpdateTurn: () -> Void
    var ApplyRoles: () -> Void
    
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
        playersList.players[gameInfo.whoseTurn].money -=
            (gameInfo.highestBet - playersList.players[gameInfo.whoseTurn].spentThisRound)
        
        playersList.players[gameInfo.whoseTurn].spentThisRound +=
            (gameInfo.highestBet - playersList.players[gameInfo.whoseTurn].spentThisRound)
             
        CheckEqualBets()
        UpdateTurn()
        ApplyRoles()
        dismiss()
    }
    
    var body: some View {
        NavigationView {
            HStack (spacing: 60) {
                Button("Call", action: Call)
                Button("Raise", action: {})
                Button("Fold", action: {})
            }
            .navigationTitle("\(playersList.players[gameInfo.whoseTurn].name)'s Actions")
            .toolbar {
                ToolbarItem (placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
        
    }
}
