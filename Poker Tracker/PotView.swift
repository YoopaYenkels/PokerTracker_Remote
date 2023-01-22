//
//  PotView.swift
//  Poker Tracker
//
//  Created by Leonidas Kalpaxis on 1/12/23.
//

import Foundation
import SwiftUI

struct Pot: Identifiable {
    var id = UUID()
    var name: String = ""
    var money: Int = 0
    var canBeWonBy: [Player] = []
}

class PotList: ObservableObject {
    @Published var pots: [Pot] = [Pot(name: "Main", money: 0)]
    var currentPot: Int = 0
    @Published var totalBets = 0
}

struct PotView: View {
    @EnvironmentObject var gameInfo: GameInfo
    @EnvironmentObject var potList: PotList
    
    var body: some View {
        VStack {
            Divider()
            
            HStack (spacing: 20){
                Image(systemName: "suit.club.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 34, height: 34)
                
                Image(systemName: "suit.heart.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 34, height: 34)
                    .foregroundColor(.red)
                
                
                Image(systemName: "suit.spade.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 34, height: 34)
                
                Image(systemName: "suit.diamond.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 34, height: 34)
                    .foregroundColor(.red)
            }
            Divider()
                .frame(width: 300, height: 4)
                .overlay(.black)
            
            ForEach(potList.pots) { pot in
                VStack{
                    Text("\(pot.name)")
                    Text("$\(pot.money)")

                    HStack {
                        ForEach (pot.canBeWonBy) {playerEligible in
                            Text("\(playerEligible.name)\(playerEligible == pot.canBeWonBy.last ? "" : ",")")
                        }
                    }.padding(.bottom, 10)
                }
                
            }
        }
        
        
        Divider()
            .frame(width: 300, height: 4)
            .overlay(.black)
        
    }
}

