import Foundation
import SwiftUI

enum Tab: String, CaseIterable {
    case house
    case message
    case person
}

struct MainTabView: View {
    @Binding var selectedTab: Tab?  // Changement ici pour être optionnel
    private var fillImage: String {
        selectedTab?.rawValue ?? "" + ".fill"
    }
    
    var body: some View {
        VStack {
            HStack {
                ForEach(Tab.allCases, id: \.rawValue) { tab in
                    Spacer()
                    
                    // Utilisation de NavigationLink pour naviguer vers les différentes vues
                    NavigationLink(destination: destinationView(for: tab), tag: tab, selection: $selectedTab) {
                        Image(systemName: selectedTab == tab ? fillImage : tab.rawValue)
                            .scaleEffect(tab == selectedTab ? 1.25 : 1.0)
                            .onTapGesture {
                                withAnimation(.easeIn(duration: 0.1)) {
                                    selectedTab = tab
                                }
                            }
                    }
                    
                    Spacer()
                }
            }
            .frame(height: 60)
            .background(.thinMaterial)
            .cornerRadius(10)
            .padding()
        }
    }
    
    // Fonction pour retourner la vue correspondante à l'onglet sélectionné
    @ViewBuilder
    private func destinationView(for tab: Tab) -> some View {
        switch tab {
        case .house:
            HomeView()
        case .message:
            PopularAnimeView() // Remplacez ceci par votre vue de popular anime
        case .person:
            ScheduleView() // Remplacez ceci par votre vue de personne
        }
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            MainTabView(selectedTab: .constant(.house)) // Ici, vous pouvez garder .house car c'est un Binding
        }
    }
}
