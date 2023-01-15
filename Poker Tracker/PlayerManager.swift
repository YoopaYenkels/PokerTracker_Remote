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
    @State private var showDeleteAllConfirmation = false
    
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
                .scrollContentBackground(.hidden)
                .background(.white)
            }
        }
        .navigationBarTitle("Manage Players")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing){
                EditButton()
                Button (role: .destructive) {
                    showDeleteAllConfirmation = true
                } label: {
                    Image(systemName: "trash")
                        .imageScale(.large)
                }
                .confirmationDialog("Confirm Delete", isPresented: $showDeleteAllConfirmation) {
                    Button ("Delete All Players", role: .destructive) {
                        playersList.deleteAllPlayers()
                    }
                } 
            }
        }
    }
}

struct Player: Identifiable {
    var id = UUID()
    var name: String = ""
    
    var money: Int = 15
    var spentThisRound: Int = 0
    
    var myRole: PlayerRole = PlayerRole.None
    var myTurn: Bool = false

    var hasPlayed: Bool = false
    var hasFolded: Bool = false
}

class PlayersList: ObservableObject {
    @Published var players: [Player] = [
        Player(name: "Alice"),
        Player(name: "Bob"),
        Player(name: "Chaz"),
        Player(name: "Dave")
//        Player(name: "Emma"),
//        Player(name: "Fred"),
//        Player(name: "Gwen"),
//        Player(name: "Hera")
//        Player(name: "Iola"),
//        Player(name: "Jeff")
    ]
    
    func deletePlayer(index: IndexSet) {
        players.remove(atOffsets: index)
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



