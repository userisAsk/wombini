//
//  TabContainer.swift
//  wombini
//
//  Created by Kyriann Paille on 13/09/2024.
//

import SwiftUI

struct TabBarContainer: View {
    @State private var selectedTab: Tab = .house

    var body: some View {
        ZStack {
            // Show the view corresponding to the selected tab
            VStack {
                switch selectedTab {
                case .house:
                    HomeView()
                case .flame:
                    TrendingView()
                case .calendar:
                    ScheduleView()
                case .heart:
                    FavoriteView()
                case .person:
                    ProfileView()
                }
                Spacer() // This pushes the custom bar to the bottom
            }

            // CustomBarView is placed at the bottom, outside of the VStack
            VStack {
                Spacer()
                CustomBarView(selectedTab: $selectedTab)
                    .padding(.bottom, 10) // Adjust as needed
            }
        }
        .edgesIgnoringSafeArea(.bottom) // Ignore safe areas at the bottom
    }
}


struct TabContainer_Previews: PreviewProvider {
    static var previews: some View {
        TabBarContainer()
    }
}
