//
//  PlayersView.swift
//  Poker Tracker
//
//  Created by Leonidas Kalpaxis on 1/12/23.
//

import Foundation
import SwiftUI

struct PlayersView: View {
    @EnvironmentObject var playersList: PlayersList
    @EnvironmentObject var gameInfo: GameInfo
    
    var body:some View {
        if playersList.players.isEmpty {
            Text("Add at least two players to begin")
                .font(.system(size: 16, weight: .regular))
        } else {
            List {
                ForEach(playersList.players) { player in
                    PlayerHomeScreenRowView(player: player)
                        .listRowBackground(player.hasFolded ? Color.gray : Color.white)
                } 
            }
            .scrollContentBackground(.hidden)
            .background(.white)
        }
    }
}

struct PlayerHomeScreenRowView: View {
    var player: Player
    
    @EnvironmentObject var playersList: PlayersList
    @EnvironmentObject var gameInfo: GameInfo
    
    var body: some View {
        HStack {
            if (player.myTurn && gameInfo.betState != .blinds) {
                Image(systemName: "arrow.right")
                    .foregroundColor(.red)
            }
            
            
            switch (player.myRole) {
            case .None:
                Label(player.name, systemImage: "")
            case .Dealer:
                Label(player.name + " (Dealer)", systemImage: "crown.fill")
                    .foregroundColor(.green)
            case .SmallBlind:
                Label {Text(player.name)} icon: {
                    Image(systemName: "eye.slash.fill")
                        .imageScale(.small)
                        .foregroundColor(.black)
                }
            case .BigBlind:
                Label(player.name, systemImage: "eye.slash.fill")
                    .foregroundColor(.black)
            }
        
            Spacer()
            
            HStack {
                Image(systemName: "arrow.up.circle")
                Text("\(player.spentThisRound)")
            }
            .padding(.trailing, 10)
            
            HStack {
                Image(systemName: "dollarsign.circle")
                Text("\(player.money)")
            }
            .foregroundColor(.secondary)
        }
    }
}
