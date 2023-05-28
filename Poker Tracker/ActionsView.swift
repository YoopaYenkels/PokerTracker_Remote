//
//  ActionsView.swift
//  Poker Tracker
//
//  Created by Leonidas Kalpaxis on 1/13/23.
//

import Foundation
import SwiftUI

struct PlacedBet : Equatable {
    var id: UUID
    var name: String
    var amount: Int
    var allIn: Bool
    var playerFolded: Bool
}

struct ActionsView: View {
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject var playersList: PlayersList
    @EnvironmentObject var gameInfo: GameInfo
    @EnvironmentObject var potList: PotList
    
    @Binding var showRaise: Bool
    @Binding var amountRaised: Int
    @Binding var showRaiseStepper: Bool

    @State private var showFoldConfirmation = false
    @State private var animateRaise = false
    
    var UpdateTurn: () -> Void
    var ApplyRoles: () -> Void
    var NewBettingRound: () -> Void
    
    
    func CreatePots() {
        var placedBets: [PlacedBet] = []
        var leastIndex: Int = 0
        var leastAmount: Int = 0
        var stillAddingToCurrentPot: Bool = false
        
        for i in 0...(playersList.players.count - 1) {
            placedBets.append(PlacedBet(id: playersList.players[i].id,
                                        name: playersList.players[i].name,
                                        amount: playersList.players[i].spentThisRound,
                                        allIn: playersList.players[i].allIn,
                                        playerFolded: playersList.players[i].hasFolded))
            
        }
        placedBets.sort { $0.amount < $1.amount }
        
        for i in 0...(placedBets.count - 1) {
            let player = playersList.players.first(where: { $0.id == placedBets[i].id })
            if ( !placedBets.allSatisfy({ ($0.amount == 0) }) &&
                 placedBets[i].allIn && placedBets[i].amount == 0 &&
                 potList.pots[potList.currentPot].canBeWonBy.contains(where: { $0.id == player!.id })) {
                potList.pots[potList.currentPot].isOpen = false
                potList.pots.append(Pot(name: "Side Pot \(potList.currentPot + 1)", money: 0))
                potList.currentPot += 1
                potList.pots[potList.currentPot].isOpen = true
                break
            }
        }
        
        while (!placedBets.allSatisfy({ ($0.amount == 0) })) {
            stillAddingToCurrentPot = false
            
            if (placedBets.firstIndex(where: { $0.allIn && $0.amount > 0 }) != nil) {
                leastIndex = placedBets.firstIndex(where: { $0.allIn && $0.amount > 0 })!
            } else {
                leastIndex = placedBets.firstIndex(where: { $0.amount > 0 && !$0.playerFolded})!
            }
            
            leastAmount = placedBets[leastIndex].amount
            for i in 0...(placedBets.count - 1) {
                if (0 < placedBets[i].amount &&
                    placedBets[i].amount < leastAmount) {
                    potList.pots[potList.currentPot].money += placedBets[i].amount
                    placedBets[i].amount = 0
                    stillAddingToCurrentPot = true
                    break
                } else if (placedBets[i].amount > 0) {
                    placedBets[i].amount -= leastAmount
                    potList.pots[potList.currentPot].money += leastAmount
                    
                    if (!potList.pots[potList.currentPot].canBeWonBy
                        .contains(where: { $0.id == placedBets[i].id }) && !placedBets[i].playerFolded) {
                        potList.pots[potList.currentPot].canBeWonBy
                            .append(playersList.players.first(where: { $0.id == placedBets[i].id })!)
                    }
                }
            }
            
            if (!placedBets.allSatisfy({ ($0.amount == 0) }) && !stillAddingToCurrentPot) {
                potList.pots[potList.currentPot].isOpen = false
                potList.pots.append(Pot(name: "Side Pot \(potList.currentPot + 1)",
                                        money: 0))
                potList.currentPot += 1
                potList.pots[potList.currentPot].isOpen = true
            }
        }
    }
    
    func CheckEqualBets() {
        gameInfo.betsEqualized = true
        
        for i in 0...(playersList.players.count - 1) {
            if (!playersList.players[i].hasFolded &&
                ((playersList.players[i].spentThisRound != gameInfo.highestBet && !playersList.players[i].allIn) ||
                 (playersList.players[i].spentThisRound == 0 && !playersList.players[i].allIn) ||
                 !playersList.players[i].hasPlayed)) {
                gameInfo.betsEqualized = false
                break
            }
        }
        
        if (gameInfo.betsEqualized ||
            gameInfo.numChecks == gameInfo.numActivePlayers) {
            CreatePots()
            NewBettingRound()
            ApplyRoles()
            dismiss()
        }
        else {
            UpdateTurn()
            ApplyRoles()
            dismiss()
        }
    }
    
    
    func Call() {
        var amountToCall = 0
        showRaise = false
        
        if ((gameInfo.highestBet - playersList.players[gameInfo.whoseTurn].spentThisRound)
            < playersList.players[gameInfo.whoseTurn].money) {
            amountToCall = gameInfo.highestBet - playersList.players[gameInfo.whoseTurn].spentThisRound
        }
        else {
            amountToCall = playersList.players[gameInfo.whoseTurn].money
            playersList.players[gameInfo.whoseTurn].allIn = true
        }
        
        playersList.players[gameInfo.whoseTurn].money -= amountToCall
        playersList.players[gameInfo.whoseTurn].spentThisRound += amountToCall
        potList.totalBets += amountToCall
        
        playersList.players[gameInfo.whoseTurn].hasPlayed = true
        
        CheckEqualBets()
    }
    
    
    func Check() {
        playersList.players[gameInfo.whoseTurn].hasPlayed = true
        gameInfo.numChecks += 1
        showRaise = false
        CheckEqualBets()
    }
    
    func ShowRaise() {
        if (playersList.players[gameInfo.whoseTurn].money >= gameInfo.highestBet 
            && (gameInfo.numRaises <= 3 ||
                playersList.players.count == 2)) {
            showRaise = true
        }
        else {
            showRaise = false
        }
        amountRaised = gameInfo.minBet
    }
    
    func ShowRaiseStepper() {
        showRaiseStepper = !showRaiseStepper
    }
    
    func RaiseAnim() {
        animateRaise.toggle()
        withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
            animateRaise.toggle()
        }
    }
    
    func SubmitRaise() {
        showRaiseStepper = false
        
        let amountToCall = (gameInfo.highestBet - playersList.players[gameInfo.whoseTurn].spentThisRound)
        
        if (amountToCall + amountRaised >= playersList.players[gameInfo.whoseTurn].money) {
            playersList.players[gameInfo.whoseTurn].allIn = true
        }
        
        playersList.players[gameInfo.whoseTurn].spentThisRound += amountToCall + amountRaised
        playersList.players[gameInfo.whoseTurn].money -= amountToCall + amountRaised
        potList.totalBets += amountToCall + amountRaised
        
        gameInfo.highestBet = playersList.players[gameInfo.whoseTurn].spentThisRound
        gameInfo.numRaises += 1
        
        playersList.players[gameInfo.whoseTurn].hasPlayed = true
        
        UpdateTurn()
        ApplyRoles()
        
        dismiss()
    }
    
    func Fold() {
        playersList.players[gameInfo.whoseTurn].hasPlayed = true
        playersList.players[gameInfo.whoseTurn].hasFolded = true
        gameInfo.numActivePlayers -= 1
        
        
        for i in 0...(potList.pots.count - 1) {
            if let index = potList.pots[i].canBeWonBy
                .firstIndex(where: { $0.id == playersList.players[gameInfo.whoseTurn].id }) {
                potList.pots[i].canBeWonBy.remove(at: index)
            }
            
        }
        CheckEqualBets()
    }
    
    var body: some View {
        VStack {
            Text("\(playersList.players[gameInfo.whoseTurn].name)'s Actions")
                .font(.system(size: 30, weight: .bold))
                .padding(.top, 20)
            HStack (spacing: 50) {
                if (!showRaiseStepper) {
                    if ((gameInfo.highestBet - playersList.players[gameInfo.whoseTurn].spentThisRound == 0) ||
                        playersList.players[gameInfo.whoseTurn].allIn) {
                        ActionButton(Action: Check,
                                     actionName: "Check",
                                     imgName: "checkmark",
                                     amountShown: 0,
                                     color: .green)
                        
                    } else if (!playersList.players[gameInfo.whoseTurn].allIn &&
                               playersList.players[gameInfo.whoseTurn].money > 0) {
                        ActionButton(Action: Call,
                                     actionName: "Call",
                                     imgName: "phone",
                                     amountShown:  (gameInfo.highestBet - playersList.players[gameInfo.whoseTurn].spentThisRound)
                                     < playersList.players[gameInfo.whoseTurn].money ? gameInfo.highestBet - playersList.players[gameInfo.whoseTurn].spentThisRound : playersList.players[gameInfo.whoseTurn].money,
                                     color: .blue)
                    }
                }
                
                if (showRaise) {
                    HStack {
                        Button {
                            ShowRaiseStepper()
                        } label: {
                            VStack {
                                VStack {
                                    Image(systemName: "arrow.up")
                                        .padding(.top, 6)
                                    Divider()
                                        .frame(width: 50, height: 2)
                                        .overlay(.gray)
                                    (gameInfo.highestBet - playersList.players[gameInfo.whoseTurn].spentThisRound + amountRaised) == playersList.players[gameInfo.whoseTurn].money ?
                                    Text("ALL IN")
                                        .padding(.bottom, 10)
                                    :Text("\(gameInfo.highestBet - playersList.players[gameInfo.whoseTurn].spentThisRound) + \(amountRaised)")
                                        .padding(.bottom, 10)
                                }
                                .frame(width: 70, height: 70)

                                .overlay(Circle()
                                    .stroke(lineWidth: 3))
                                Text("Raise")
                            }
                            .offset(x: animateRaise ? (showRaiseStepper ? 100 : -50) : 0)
                            .padding(.leading, (showRaiseStepper ? 40 : 0))
                            .foregroundColor(.gray)
                        }
                        
                        if (showRaiseStepper) {
                            HStack {
                                Stepper (value: $amountRaised,
                                         in: (playersList.players[gameInfo.whoseTurn].money >= gameInfo.highestBet ?
                                              
                                              (gameInfo.minBet...playersList.players[gameInfo.whoseTurn].money - gameInfo.highestBet ) :
                                                
                                                (0...0)
                                              )
                                )
                                {}
                                    .scaleEffect(animateRaise ? 0 : 1)
                                    .padding(.bottom, 30)
                                    .padding(.trailing, 30)
                                    .onAppear {
                                        RaiseAnim()
                                    }
                                    .onDisappear() {
                                        RaiseAnim()
                                    }
                                
                                
                                ActionButton(Action: SubmitRaise,
                                             actionName: "Confirm",
                                             imgName: "checkmark",
                                             amountShown: gameInfo.highestBet - playersList.players[gameInfo.whoseTurn].spentThisRound + amountRaised,
                                             color: .green)
                                .offset(x: animateRaise ? (showRaiseStepper ? -100 : 50) : 0)
                                .padding(.trailing, (showRaiseStepper ? 40 : 0))
                            }
  
                        }
                    }
                    
                }
                
                if (!showRaiseStepper) {
                    Button {
                        showFoldConfirmation.toggle()
                    } label: {
                        VStack {
                            Text("X")
                                .font(.system(size: 30, weight: .bold))
                                .frame(width: 70, height: 70)
                                .overlay(Circle()
                                    .stroke(lineWidth: 3))
                            Text("Fold")
                        }
                        
                    }
                    .foregroundColor(.red)
                    .confirmationDialog("Confirm Fold", isPresented: $showFoldConfirmation) {
                        Button ("Fold", role: .destructive) {
                            Fold()
                        }
                    } message: {
                        Text("Are you sure?")
                    }
                }
            }
        }
        .onAppear(perform: ShowRaise)
    }
    
    struct ActionButton: View {
        var Action: () -> Void
        
        var actionName : String
        var imgName: String
        var amountShown: Int
        var color: Color
        
        @EnvironmentObject var playersList: PlayersList
        @EnvironmentObject var gameInfo: GameInfo
        
        var body: some View {
            Button {
                Action()
            } label: {
                VStack {
                    VStack {
                        Image(systemName: imgName)
                            .padding(.top, 6)
                        Divider()
                            .frame(width: 50, height: 2)
                            .overlay(color)
                        Text("\(amountShown)")
                            .padding(.bottom, 6)
                        
                    }
                    .frame(width: 70, height: 70)
                    .overlay(Circle()
                        .stroke(lineWidth: 3))
                    Text("\(actionName)")
                }
                
            }
            .foregroundColor(color)
        }
    }
    
    struct MoneyStatusView: View {
        var text: String
        var image1: String
        var image2: String
        
        var moneySpent: Int
        var totalMoney: Int
        
        var body: some View {
            HStack {
                Text(text)
                Spacer()
                Image(systemName: image1)
                Text("\(moneySpent)")
                
                HStack {
                    Image(systemName: image2)
                    Text("\(totalMoney)")
                }
                .foregroundColor(.secondary)
            }
        }
    }
    
    struct ActionsView_Previews: PreviewProvider {
        static var previews: some View {
            MainView()
                .environmentObject(GameInfo())
                .environmentObject(PlayersList())
                .environmentObject(PotList())
        }
    }
}
