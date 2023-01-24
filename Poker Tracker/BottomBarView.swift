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
    @EnvironmentObject var potList: PotList
    
    @State private var showActions = false
    @State private var showRaise = false
    @State private var showGivePot = false
    @State private var amountRaised = 0
    
    var AddBlinds: () -> Void
    var NewHand: () -> Void
    var UpdateTurn: () -> Void
    var ApplyRoles: () -> Void
    var NewBettingRound: () -> Void
    
    var body: some View {
        if (playersList.players.count > 1) {
            VStack {
                //Text("show raise: \(String(showRaise))")
                if (gameInfo.bettingRound == 0) {
                    Button {
                        self.NewHand()
                        self.AddBlinds() 
                    } label: {
                        Text("Begin Hand")
                    }
                    .buttonStyle(.borderedProminent)
                    
                } else if (!gameInfo.betsEqualized && gameInfo.bettingRound <= 4) {
                    Button {
                        showActions.toggle()
                    } label: {
                        Text("\(playersList.players[gameInfo.whoseTurn].name)'s Turn")
                    }
                    .buttonStyle(.borderedProminent)
                    .sheet(isPresented: $showActions) {
                        ActionsView(showRaise: $showRaise,
                                    amountRaised: $amountRaised,
                                    UpdateTurn: UpdateTurn,
                                    ApplyRoles: ApplyRoles,
                                    NewBettingRound: NewBettingRound)
                        .presentationDetents([.fraction(0.2)])
                    }.onDisappear(perform: {
                        amountRaised = gameInfo.minBet
                    })
                } else if (!gameInfo.potGiven) {
                    Button {
                        showGivePot.toggle()
                    } label: {
                        Text("SHOWDOWN")
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.black)
                    .sheet(isPresented: $showGivePot) {
                        GivePot()
                            .presentationDetents([.medium])
                    }
                }
            }
        }
    }
}
