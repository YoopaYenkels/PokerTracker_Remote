//
//  CustomNavBarView.swift
//  Poker Tracker
//
//  Created by Leonidas Kalpaxis on 1/23/23.
//

import SwiftUI

struct CustomNavBarView: View {
    @State private var showBackButton: Bool = true
    @State private var title: String = "Manage Players"
    @State private var subtitle: String = "subtitle"
    
    var body: some View {
        HStack {
            if (showBackButton) {
                backButton
            }
            Spacer()
            titleSection
            Spacer()
            if (showBackButton) {
                backButton
                .opacity(0) }
                
        }
        .padding()
        .font(.headline)
        .foregroundColor(.white)
        .background(LinearGradient(colors: [Color("bgColor2"), Color.green], startPoint: .topLeading, endPoint: .bottomTrailing))
    }
}

struct CustomNavBarView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            CustomNavBarView()
            Spacer()
        }
    }
}

extension CustomNavBarView {
    private var backButton: some View {
        Button(action : {
            
        }, label : {
            Image(systemName: "arrow.left")
        })
    }
    
    private var titleSection: some View {
        VStack (spacing: 4) {
            Text(title)
                .font(.title)
                .fontWeight(.semibold)
            if let subtitle = subtitle {
                Text(subtitle)
            }
        }
    }
}
