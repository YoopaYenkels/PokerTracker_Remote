//
//  ContentView.swift
//  Poker Tracker
//
//  Created by Leonidas Kalpaxis on 1/9/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "heart.fill")
                .imageScale(.large)
                .foregroundColor(.accentColor)
                .padding()
            Text("Poker Tracker Main View")
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
