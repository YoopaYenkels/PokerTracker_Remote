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

struct Player: Identifiable, Equatable {
    var id = UUID()
    var name: String = ""
    
    var money: Int = 15
    var spentThisRound: Int = 0
    
    var myRole: PlayerRole = PlayerRole.None
    var myTurn: Bool = false
    
    var allIn: Bool = false
    var hasPlayed: Bool = false
    var hasFolded: Bool = false
}

class PlayersList: ObservableObject {
    @Published var players: [Player] = [
        Player(name: "Alice", money: 10),
        Player(name: "Bob", money:  20),
        Player(name: "Chaz", money: 30),
        Player(name: "Dave", money: 40),
        Player(name: "Emma", money: 50)
//        Player(name: "Fred", money: 12),
//        Player(name: "Gwen", money: 12),
//        Player(name: "Hera", money: 12)
//        Player(name: "Iola", money: 12),
//        Player(name: "Jeff", money: 12)
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
        NavigationLink {} label: {
            HStack {
                Text(player.name)
                    .font(.system(size: 20, weight: .regular))
                    .foregroundColor(.black)
                
                Spacer()
                
                Label("\(player.money)", systemImage: "dollarsign.circle")
                    .foregroundColor(.secondary)
                    .font(.system(size: 20, weight: .light))
            }
            
        }
    }
}



