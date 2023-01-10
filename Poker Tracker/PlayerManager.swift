//
//  PlayerManager.swift
//  Poker Tracker
//
//  Created by Leonidas Kalpaxis on 1/10/23.
//

import Foundation
import SwiftUI

struct PlayerManager: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            HStack {
                Text("Manage Players")
                    .font(.system(size: 32, weight: .bold))
                    .frame(width: 240, alignment: .leading)
                Button() {
                    dismiss()
                } label: {
                    Text("Done")
                        .font(.system(size: 24, weight: .bold))
                        .frame(width: 100, alignment: .trailing)
                        .foregroundColor(.blue)
                }
            }.padding(.top, 30)
            
            List {
                ForEach(players) {player in
                    PlayerRowView(player: player)
                }
            }
            
            HStack {
                Button() {
                    
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 26, height: 26, alignment: .leading)
                    Text("Add Player")
                        .font(.system(size: 20, weight: .regular))
                        .foregroundColor(.blue)
                }
                Spacer()
                Button() {
                    
                } label: {
                    Text("Edit")
                        .font(.system(size: 20, weight: .regular))
                        .foregroundColor(.blue)
                }
            }.padding()
        }
    }
}

struct Player: Identifiable {
    var id = UUID()
    var name: String
    var money: Int
}


var players = [
    Player(name: "Daki", money: 300),
    Player(name: "Nike", money: 400),
    Player(name: "Daddy", money: 800),
    Player(name: "Julenisse", money: 300),
    Player(name: "Mommy", money: 600),
    Player(name: "Jupiter", money: 100),
    Player(name: "Maul", money: 900),
    Player(name: "Beary Bear", money: 500),
    Player(name: "Goldie", money: 500)
]

struct PlayerRowView: View {
    var player: Player
    var body: some View {
        HStack {
            Text(player.name)
                .font(.system(size: 30, weight: .regular))
            
            Spacer()
            
            Label("\(player.money)", systemImage: "dollarsign.circle")
            
                .foregroundColor(.secondary)
            .font(.system(size: 24, weight: .light))
        }.frame(height: 40)
    }
}



