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
    @State private var startingMoney = 15
    
    @EnvironmentObject var playersList: PlayersList
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Enter Name", text: $name)
                Stepper(value: $startingMoney, in: 1...50) {
                    VStack {
                        Text("Starting Money")
                        Label("\(startingMoney)", systemImage: "dollarsign.circle")
                    }
                    
                }
            }
            .navigationTitle("Add Player")
            .toolbar {
                Button {
                    name != "" ?
                    playersList.players
                        .append(Player(name: name, money: startingMoney)) : dismiss()
                    dismiss()
                } label: {
                    Text("Done")
                        .fontWeight(.bold)
                }
            }
        }
        
    }
}
