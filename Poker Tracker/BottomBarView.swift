//
//  ActionsView.swift
//  Poker Tracker
//
//  Created by Leonidas Kalpaxis on 1/12/23.
//

import Foundation
import SwiftUI

struct BottomBarView:View {
    @EnvironmentObject var playersList: PlayersList
    @EnvironmentObject var gameInfo: GameInfo
    
    @State private var showActions = false
    @State private var showRaise = false
    @State private var amountRaised = 0
    
    var AddBlinds: () -> Void
    var NewHand: () -> Void
    var UpdateTurn: () -> Void
    var ApplyRoles: () -> Void
    var NewBettingRound: () -> Void
    
    var body: some View {
        if (playersList.players.count > 1) {
            VStack {
                if (gameInfo.betState == .blinds) {
                    Button ("Begin Hand", action: self.NewHand)
                        .buttonStyle(.borderedProminent)
                } else if (!gameInfo.betsEqualized ||
                        (gameInfo.betsEqualized && playersList.players[gameInfo.whoseTurn].myRole == PlayerRole.BigBlind)) {
                        Button {
                            showActions.toggle()
                        } label: {
                            Text("\(playersList.players[gameInfo.whoseTurn].name)'s Turn")
                        }
                        .buttonStyle(.bordered)
                        .sheet(isPresented: $showActions) {
                            ActionsView(showRaise: $showRaise,
                                        amountRaised: $amountRaised,
                                        UpdateTurn: UpdateTurn,
                                        ApplyRoles: ApplyRoles,
                                        NewBettingRound: NewBettingRound)
                                .presentationDetents([.medium])
                        }.onDisappear(perform: {amountRaised = gameInfo.minBet})
                    }
                }
            }
        }
        
    }
    
struct ActionButton: View {
    var text: String

    var body: some View {
        Button(text, action: {})
            .foregroundColor(.white)
            .frame(width: 100, height: 50)
    }
}
