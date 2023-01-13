//
//  ActionsView.swift
//  Poker Tracker
//
//  Created by Leonidas Kalpaxis on 1/12/23.
//

import Foundation
import SwiftUI

//struct ActionsView:View {
//    @EnvironmentObject var playersList: PlayersList
//    @EnvironmentObject var gameInfo: GameInfo
//    
//    func UpdateDealer() {
//        if ((gameInfo.whoIsDealer + 2) > playersList.players.count) {
//            gameInfo.whoIsDealer = 0;
//        } else {
//            gameInfo.whoIsDealer += 1
//        }
//    }
//    
//    var body: some View {
//        Button ("New Round", action: UpdateDealer)
//            .buttonStyle(.borderedProminent)
//    }
//}

//struct ActionButton: View {
//    var text: String
//
//    var body: some View {
//        Button(text , action: {})
//            .foregroundColor(.white)
//            .frame(width: 100, height: 50)
//    }
//}
//struct ActionsView: View {
//    var body: some View {
//        HStack (spacing: 20) {
//            ActionButton(text: "Call")
//                .font(.system(size: 30, weight: .bold))
//                .background(Color("bgColor1"))
//                .cornerRadius(10)
//            ActionButton(text: "Raise")
//                .font(.system(size: 30, weight: .bold))
//                .background(.blue)
//                .cornerRadius(10)
//            ActionButton(text: "Fold")
//                .font(.system(size: 30, weight: .bold))
//                .background(.red)
//                .cornerRadius(10)
//        }.padding()
//    }
//}
