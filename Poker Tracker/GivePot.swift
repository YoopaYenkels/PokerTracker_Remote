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
    
    @State var selection = Set<UUID>()
    
    func AwardPot() {
        for i in 0...(playersList.players.count - 1) {
            if (selection.contains(playersList.players[i].id)) {
                playersList.players[i].money += potList.pots[potList.currentPot].money/selection.count
            }
        }

        if (potList.currentPot > 0) {
            //potList.pots.remove(at: potList.currentPot)
            potList.pots[potList.currentPot].money = 0
            potList.currentPot -= 1
            dismiss()
        } else {
            potList.pots[potList.currentPot].money = 0
            potList.pots[potList.currentPot].canBeWonBy.removeAll()
            gameInfo.potGiven = true
        }
       
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                Text( "Select the winning player(s) for \(potList.currentPot == 0 ? "the Main Pot:" : "Side Pot \(potList.currentPot):") ")
                    .fontWeight(.bold)
                
                List (potList.pots[potList.currentPot].canBeWonBy, selection: $selection) {
                    Text($0.name)
                }
                .scrollContentBackground(.hidden)
                .background(.white)
                
                
                Button (potList.currentPot == 0 ? "Award Main Pot" : "Award Side Pot \(potList.currentPot)", action: AwardPot)
                    .buttonStyle(.borderedProminent)
                
                .toolbar {
                    EditButton()
                }
            }
        }
    }
}
