//
//  CustomBarView.swift
//  wombini
//
//  Created by Kyriann Paille on 13/09/2024.
//

import SwiftUI

enum  Tab: String, CaseIterable {
    case house
    case flame
    case calendar
    case heart
    case person
}

struct CustomBarView: View {
    @Binding var selectedTab: Tab
    private var fillImage: String {
        selectedTab.rawValue + ".fill"
    }
    
    
    var body: some View {
        VStack {
            HStack{
                ForEach(Tab.allCases, id: \.rawValue) { tab in
                    Spacer()
                    Image(systemName: selectedTab == tab  ? fillImage :
                            tab.rawValue)
                            .scaleEffect(selectedTab == tab ? 1.25 : 1.0)
                            .foregroundColor(selectedTab == tab ? .blue : .gray)
                            .font(.system(size: 20))
                            .onTapGesture {
                                withAnimation(.easeIn(duration: 0.1)) {
                                    selectedTab = tab
                                }
                            }
                    Spacer()
                }
            }
            .frame(width: nil, height: 60)
            .background(.thinMaterial)
            .cornerRadius(10)
            .padding()
        }
    }
}

struct CustomBarView_Previews: PreviewProvider {
    static var previews: some View {
        CustomBarView(selectedTab: .constant(.house))
    }
}
