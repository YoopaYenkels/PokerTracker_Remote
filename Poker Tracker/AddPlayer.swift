//
//  AddPlayer.swift
//  Poker Tracker
//
//  Created by Leonidas Kalpaxis on 1/10/23.
//

import Foundation
import SwiftUI

struct AddPlayer:View {
    @Environment(\.dismiss) var dismiss
    
    @State private var name = ""
    @State private var startingMoney = 100
    
    @ObservedObject var observedPlayersList: PlayersList
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Enter Name", text: $name)
                Picker("Starting Money:", selection: $startingMoney) {
                    ForEach(1...500, id:\.self) {
                        Text("\($0)")
                    }
                }
            }
            .navigationTitle("Add Player")
            .toolbar {
                Button("Done") {
                    observedPlayersList.players.append(Player(name: name, money: startingMoney))
                    dismiss()
                }
            }
        }
        
    }
}
