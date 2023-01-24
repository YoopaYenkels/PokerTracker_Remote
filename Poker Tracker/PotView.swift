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
    var isOpen: Bool = false
}

class PotList: ObservableObject {
    @Published var pots: [Pot] = [Pot(name: "Main", money: 0, isOpen: true)]
    var currentPot: Int = 0
    @Published var totalBets = 0
}


struct PotView: View {
    @EnvironmentObject var gameInfo: GameInfo
    @EnvironmentObject var potList: PotList
    
//    func AddNumberWithRollingAnimation(startNum: Int, targetNum: Int) {
//        withAnimation {
//            let animationDuration = 1000 // milliseconds
//            let stepDuration = animationDuration / 30
//
//            for step in (0..<abs(targetNum)) {
//                let updateTimeInterval = DispatchTimeInterval.milliseconds(step * stepDuration)
//                let deadline = DispatchTime.now() + updateTimeInterval
//
//                DispatchQueue.main.asyncAfter(deadline: deadline) {
//                    startNum = targetNum / abs(targetNum)
//                }
//            }
//        }
//    }
    
    var body: some View {
        VStack {
            HStack (spacing: 30){
//                Text("\(potList.pots[0].money)")
//                    .background(Circle()
//                    .scale(1.4)
//                    .fill(.white))
//                Button("TEST", action: { AddNumberWithRollingAnimation(startNum: potList.pots[0].money, targetNum: -10) })
//                    .buttonStyle(.borderedProminent)
                PipView(pipName: "suit.club.fill", color: Color.black)
                PipView(pipName: "suit.heart.fill", color: Color.red)
                PipView(pipName: "suit.spade.fill", color: Color.black)
                PipView(pipName: "suit.diamond.fill", color: Color.red)
            }.padding()
            
            Divider()
                .frame(width: 300, height: 4)
                .overlay(.black)
            
            ForEach(potList.pots) { pot in
                VStack {
                    HStack {
                        VStack (alignment: .leading) {
                            Label {
                                Text(pot.name)
                                    .font(.system(size: 18, weight: .light))
                            } icon: {
                                Image(systemName: pot.isOpen ? "trophy" : "trophy.fill")
                            }
                            
                            Divider()
                            
                            Menu {
                                if (!pot.canBeWonBy.isEmpty) {
                                    ForEach (pot.canBeWonBy) {playerEligible in
                                        Text("\(playerEligible.name)")
                                    }
                                } else { Text("None") }
                            } label: {
                                Label {
                                    Text("Eligible Players")
                                        .font(.system(size: 12, weight: .light))
                                } icon: {
                                    Image(systemName: "person.2.fill")
                                        .imageScale(.small)
                                }
                                
                            }
                        }
                        
                        Spacer()
                        ZStack {
                            Text("\(pot.money)")
                                .font(.system(size: 20, weight: .light))
                                .frame(width: 60, height: 60)
                                .overlay(Circle()
                                    .stroke(pot.isOpen ? .white : .black, lineWidth: 2))
                        }
                        
                    }
                    .padding(.horizontal, 20)
                    .frame(width: 300, height: 80)
                    .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 10))
                    
                }
                
            }
        }
        
        
        
    }
    
}

struct PipView: View {
    var pipName: String
    var color: Color
    var body: some View {
        Image(systemName: pipName)
            .resizable()
            .scaledToFit()
            .frame(width: 34, height: 34)
            .foregroundColor(color)
            .background(Circle()
                .scale(1.4)
                .fill(.white))
    }
}
