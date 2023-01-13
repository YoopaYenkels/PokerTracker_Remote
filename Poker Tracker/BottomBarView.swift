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
    
    var AddBlinds: () -> Void
    var NewRound: () -> Void
    
    var body: some View {
        if (playersList.players.count > 1) {
            VStack {
                if (gameInfo.gameState == .blinds) {
                    Button ("Begin Round", action: self.AddBlinds)
                        .buttonStyle(.borderedProminent)
                } else if (gameInfo.gameState == .preflop) {
                    HStack (spacing: 20) {
                        ActionButton(text: "Call")
                            .font(.system(size: 30, weight: .bold))
                            .background(Color("bgColor1"))
                            .cornerRadius(10)
                        ActionButton(text: "Raise")
                            .font(.system(size: 30, weight: .bold))
                            .background(.blue)
                            .cornerRadius(10)
                        ActionButton(text: "Fold")
                            .font(.system(size: 30, weight: .bold))
                            .background(.red)
                            .cornerRadius(10)
                    }.padding()
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
