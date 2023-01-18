//
//  Poker_TrackerApp.swift
//  Poker Tracker
//
//  Created by Leonidas Kalpaxis on 1/9/23.
//

import SwiftUI

@main
struct Poker_TrackerApp: App {
    @StateObject var gameInfo = GameInfo()
    @StateObject var playersList = PlayersList()
    @StateObject var potList = PotList()
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(gameInfo)
                .environmentObject(playersList)
                .environmentObject(potList)
        }
    }
}
