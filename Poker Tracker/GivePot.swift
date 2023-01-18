//
//  GivePot.swift
//  Poker Tracker
//
//  Created by Leonidas Kalpaxis on 1/16/23.
//

import Foundation
import SwiftUI

struct GivePot: View {
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject var playersList: PlayersList
    @EnvironmentObject var gameInfo: GameInfo
    @EnvironmentObject var potList: PotList
    
    @State private var selection = Set<UUID>()
    
    func AwardPot() {
        for i in 0...(playersList.players.count - 1) {
            if (selection.contains(playersList.players[i].id)) {
                playersList.players[i].money += potList.pots[0].money/selection.count
            }
        }
        potList.pots[0].money = 0
        gameInfo.potGiven = true
        
        dismiss()
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Select the winning player(s):")
                    .fontWeight(.bold)
                
                List (playersList.players, selection: $selection) {
                    if (!$0.hasFolded) {
                        Text($0.name)
                    }
                }
                .scrollContentBackground(.hidden)
                .background(.white)
                
                
                Button ("Award Pot", action: AwardPot)
                    .buttonStyle(.borderedProminent)
                
                .toolbar {
                    EditButton()
                }
            }
        }
    }
}
