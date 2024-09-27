import SwiftUI

struct ContentView: View {
    @State private var selectedTab: Tab = .house

    init() {
        UITabBar.appearance().isHidden = true
    }

    var body: some View {
        TabBarContainer() // Remplacer TabBarContainer() par SplashScreenView()
    }
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }
}
