//
//  PlayerManager.swift
//  Poker Tracker
//
//  Created by Leonidas Kalpaxis on 1/10/23.
//

import Foundation
import SwiftUI

struct PlayerManager: View {
    @State private var showAddPlayer = false

    @EnvironmentObject var playersList: PlayersList
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    ForEach(playersList.players) {player in
                        PlayerRowView(player: player)
                    }
                    .onDelete(perform: playersList.deletePlayer)
                    
                    Button {
                        showAddPlayer.toggle()
                    } label: {
                        HStack {
                            Image(systemName: "plus")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 16, height: 16, alignment: .leading)
                            Text("Add Player")
                                .font(.system(size: 20, weight: .regular))
                                .foregroundColor(.blue)
                        }
                    }.sheet(isPresented: $showAddPlayer) {
                        AddPlayer()
                            .presentationDetents([.medium])
                    }
                }
            }
        }
        .navigationBarTitle("Manage Players")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing){
                EditButton()
                Button {
                    playersList.deleteAllPlayers()
                
                } label: {
                    Image(systemName: "trash")
                        .imageScale(.large)
                }
            }
        }
    }
}

struct Player: Identifiable {
    var id = UUID()
    var name: String = ""
    var money: Int = 0
    
    var myRole: PlayerRole = PlayerRole.None
//    var isMyTurn: Bool = false
}

class PlayersList: ObservableObject {
    @Published var players: [Player] = [
        Player(name: "Alice", money: 15),
        Player(name: "Bob", money: 15),
        Player(name: "Chaz", money: 15),
        Player(name: "Dave", money: 15),
        Player(name: "Emma", money: 15),
        Player(name: "Fred", money: 15),
        Player(name: "Gwen", money: 15),
        Player(name: "Hera", money: 15)
//        Player(name: "Iola", money: 15),
//        Player(name: "Jeff", money: 15)

    ]
    
    func deletePlayer(index: IndexSet) {
        players.remove(atOffsets: index)
        print("Player no.: \(players.count)")
    }
    
    func deleteAllPlayers() {
        players.removeAll()
    }
}

struct PlayerRowView: View {
    var player: Player
    var body: some View {
        HStack {
            Text(player.name)
                .font(.system(size: 20, weight: .regular))
            
            Spacer()
            
            Label("\(player.money)", systemImage: "dollarsign.circle")  
                .foregroundColor(.secondary)
                .font(.system(size: 24, weight: .light))
        }.frame(height: 20)
        
    }
}



