//
//  PlayerManager.swift
//  Poker Tracker
//
//  Created by Leonidas Kalpaxis on 1/10/23.
//

import Foundation
import SwiftUI

// this view creates and owns the players list object
struct PlayerManager: View {
    @State private var showAddPlayer = false

    @ObservedObject var observedPlayersList: PlayersList
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    ForEach(observedPlayersList.players) {player in
                        PlayerRowView(player: player)
                    }
                    .onDelete(perform: observedPlayersList.deletePlayer)
                }

                HStack {
                    Button {
                        showAddPlayer.toggle()
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 26, height: 26, alignment: .leading)
                        Text("Add Player")
                            .font(.system(size: 20, weight: .regular))
                            .foregroundColor(.blue)
                    }.sheet(isPresented: $showAddPlayer) {
                        AddPlayer(observedPlayersList: observedPlayersList)
                            .presentationDetents([.medium])
                    }

                }.padding()
            }
        }
        .navigationBarTitle("Manage Players")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing){
                Button {
                    observedPlayersList.deleteAllPlayers()
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
    var name: String
    var money: Int
}

class PlayersList: ObservableObject {
    @Published var players: [Player] = []
    
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
                .font(.system(size: 30, weight: .regular))
            
            Spacer()
            
            Label("\(player.money)", systemImage: "dollarsign.circle")  
                .foregroundColor(.secondary)
                .font(.system(size: 24, weight: .light))
        }.frame(height: 20)
    }
}



