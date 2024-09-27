import SwiftUI

struct HomeView: View {
    @StateObject private var controller = AnimeListViewController() // État de l'objet pour le contrôleur
    @State private var currentIndex = 0 // Index pour le slider

    var body: some View {
        ZStack {
            // Couleur de fond
            Color.black
                .edgesIgnoringSafeArea(.all)

            // Slider d'animes
            TabView(selection: $currentIndex) {
                // Vérifier que animeList contient des éléments
                if !controller.animeList.isEmpty {
                    ForEach(controller.animeList.indices, id: \.self) { index in
                        // Créer une vue pour chaque anime
                        AnimeView(anime: controller.animeList[index])
                            .tag(index) // Taguer chaque vue avec son index
                    }
                } else {
                    // Afficher un message si aucune donnée n'est disponible
                    Text("Aucun anime disponible.")
                        .foregroundColor(.white)
                        .font(.title)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always)) // Style de page pour le TabView
            .padding(.top, 50) // Ajuste la position du slider
        }
        .onAppear {
            controller.fetchAnimeData() // Récupérer les données des animes lors de l'apparition de la vue
        }
    }
}

// Vue personnalisée pour chaque anime
struct AnimeView: View {
    var anime: AnimeModel? // Le modèle d'anime

    var body: some View {
        VStack {
            // Détails de l'anime
            if let anime = anime {
                ZStack(alignment: .bottomLeading) {
                    // Afficher l'image de couverture avec une largeur presque maximale
                    if let url = anime.coverImage.large, let imageUrl = URL(string: url) {
                        AsyncImage(url: imageUrl) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill) // Remplir l'espace tout en gardant les proportions
                                .frame(width: UIScreen.main.bounds.width * 0.95, height: 200) // Largeur presque totale de l'écran et hauteur fixe
                                .clipped() // Élaguer l'image pour éviter les débordements
                                .cornerRadius(15) // Coin arrondi
                        } placeholder: {
                            ProgressView()
                        }
                    }

                    // Titre de l'anime sans fond avec taille de police réduite
                    Text(anime.title.romaji)
                        .font(.headline) // Réduit la taille du texte
                        .foregroundColor(.white)
                        .padding(10)
                        .padding([.bottom, .leading], 10) // Padding en bas et à gauche
                }
                .padding()
                .background(Color.black.opacity(0.7)) // Ajouter un fond semi-transparent pour le texte
                .cornerRadius(10)
                .padding()
            } else {
                // Afficher un message si aucun anime n'est disponible
                Text("Aucun anime disponible.")
                    .foregroundColor(.white)
                    .font(.title)
            }
        }
    }
}

// Prévisualisation
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environment(\.colorScheme, .dark)
            .previewLayout(.sizeThatFits)
    }
}
