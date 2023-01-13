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
            Text("(No Players)")
                .font(.system(size: 30, weight: .regular))
                .padding(.top, 30)
        } else {
            List {
                ForEach(Array(zip(playersList.players.indices, playersList.players)), id: \.0) { index, player in
                    PlayerHomeScreenRowView(
                        player: player,
                        playerIndex: index
                    )
                }
            }
            .background(.white)
            .scrollContentBackground(.hidden)
        }
    }
}

struct PlayerHomeScreenRowView: View {
    var player: Player
    var playerIndex: Int
    
    @EnvironmentObject var playersList: PlayersList
    @EnvironmentObject var gameInfo: GameInfo
    
    var body: some View {
        HStack {
            switch (playersList.players[playerIndex].myRole) {
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
            Label("\(player.money)", systemImage: "dollarsign.circle")
                .foregroundColor(.secondary)
        }
    }
}
