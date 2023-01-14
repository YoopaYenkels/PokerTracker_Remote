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
    
    var AddBlinds: () -> Void
    var NewRound: () -> Void
    var UpdateTurn: () -> Void
    var ApplyRoles: () -> Void
    
    var body: some View {
        if (playersList.players.count > 1) {
            VStack {
                if (gameInfo.gameState == .blinds) {
                    Button ("Begin Hand", action: self.AddBlinds)
                        .buttonStyle(.borderedProminent)
                } else if (gameInfo.gameState == .preflop) {
                    Button {
                        showActions.toggle()
                    } label: {
                        Text("\(playersList.players[gameInfo.whoseTurn].name)'s Turn")
                            .font(.system(size: 30, weight: .regular))
                            .foregroundColor(.blue)
                    }
                    .buttonStyle(.bordered)
                    .sheet(isPresented: $showActions) {
                        ActionsView(UpdateTurn: UpdateTurn,
                        ApplyRoles: ApplyRoles)
                            .presentationDetents([.medium])
                    }
                }
            }
        }
        
    }
    
}

struct ActionButton: View {
    var text: String

    var body: some View {
        Button(text , action: {})
            .foregroundColor(.white)
            .frame(width: 100, height: 50)
    }
}
