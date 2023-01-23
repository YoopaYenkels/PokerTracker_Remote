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
            ScrollView {
                ForEach(playersList.players) { player in
                    PlayerHomeScreenRowView(player: player)
                }
            }
            //.scrollContentBackground(.hidden)
            //.padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
        }
    }
}

struct PlayerHomeScreenRowView: View {
    var player: Player
    
    @EnvironmentObject var playersList: PlayersList
    @EnvironmentObject var gameInfo: GameInfo
    
    var body: some View {
        HStack {
            if (player.myTurn && gameInfo.bettingRound != 0) {
                Image(systemName: "arrow.right")
                    .foregroundColor(.red)
            }
              
            switch (player.myRole) {
            case .None:
                Text(player.name)
                    .foregroundColor(player.myTurn && gameInfo.bettingRound != 0 ? .red : .black)
            case .Dealer:
                HStack {
                    Text(player.name)
                    Image(systemName: "crown")
                        
                }
                .foregroundColor(player.myTurn ? .red : .black)
            case .SmallBlind:
                HStack {
                    Text(player.name)
                        .foregroundColor(player.myTurn ? .red : .black)
                    Image(systemName: "eye.slash")
                        .imageScale(.small)
                }
                .foregroundColor(player.myTurn ? .red : .black)
            case .BigBlind:
                HStack {
                    Text(player.name)
                    Image(systemName: "eye.slash.fill")
                }
                .foregroundColor(player.myTurn ? .red : .black)
            }
        
            Spacer()
            
            HStack {
                Image(systemName: "arrow.up.circle")
                Text("\(player.spentThisRound)")
            }
            .padding(.trailing, 10)
            .foregroundColor(player.myTurn && gameInfo.bettingRound != 0 ? .red : .black)
            
            HStack {
                Image(systemName: "dollarsign.circle")
                Text("\(player.money)")
                    
            }
            .foregroundColor(player.myTurn && gameInfo.bettingRound != 0 ? .red : .secondary)
            
        }
        .padding(.horizontal, 30)
        .frame(width: 300, height: 40)
        .background(
            player.hasFolded
                ?.ultraThinMaterial
                :player.myTurn && gameInfo.bettingRound != 0
                    ? .ultraThickMaterial
                    : .regularMaterial
                , in: RoundedRectangle(cornerRadius: 10))
//        .overlay(RoundedRectangle(cornerRadius: 6)
//            .stroke(.red, lineWidth: (player.myTurn && gameInfo.bettingRound != 0) ? 3: 0))
    }
}
