import SwiftUI

extension Color {
    static let customBackgroundColor = Color(red: 0.179, green: 0.180, blue: 0.192) // Valeurs RGB pour #2D2E31
}


struct HomeView: View {
    var body: some View {
        ZStack {
            // Couleur de fond de la vue entière
            Color.customBackgroundColor
                .edgesIgnoringSafeArea(.all) // Ignore les zones sécurisées pour que la couleur de fond atteigne les bords de l'écran

            VStack(alignment: .leading) {
                // Ajoutez une image à partir de vos assets
                

                Spacer() // Permet de pousser le contenu vers le haut
            }
            .padding() // Ajoute un peu d'espace autour de la VStack
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
