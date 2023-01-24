//
//  AppNavBarView.swift
//  Poker Tracker
//
//  Created by Leonidas Kalpaxis on 1/23/23.
//

import SwiftUI

struct AppNavBarView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                Color.green.ignoresSafeArea()
                NavigationLink (
                    destination: Text("Destination!")
                        .navigationTitle("Title 2")
                        .navigationBarBackButtonHidden(false),
                    label:  {
                        Text("Navigate")
                            .foregroundColor(.white)
                    })
            }
            .navigationTitle("Nav Title Here!")
        }
    }
}

struct AppNavBarView_Previews: PreviewProvider {
    static var previews: some View {
        AppNavBarView()
    }
}
