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
                ForEach(playersList.players) { player in
                    PlayerHomeScreenRowView(player: player)
                }
            }
            .background(.white)
            .scrollContentBackground(.hidden)
        }
    }
}

struct PlayerHomeScreenRowView: View {
    var player: Player
    
    @EnvironmentObject var playersList: PlayersList
    @EnvironmentObject var gameInfo: GameInfo
    
    var body: some View {
        HStack {
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
            Label("\(player.money)", systemImage: "dollarsign.circle")
                .foregroundColor(.secondary)
        }
    }
}
