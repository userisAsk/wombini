//
//  ContentView.swift
//  wombini
//
//  Created by Kyriann Paille on 13/09/2024.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab: Tab = .house
    
    init() {
        UITabBar.appearance().isHidden = true
    }
    
    var body: some View {
        TabBarContainer()
    }
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }
}

