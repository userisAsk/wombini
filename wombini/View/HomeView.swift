import SwiftUI
import Combine // Importer Combine pour le Timer

extension Color {
    static let customBackgroundColor = Color(red: 20 / 255, green: 20 / 255, blue: 20 / 255)
}



struct HomeView: View {
    @StateObject private var controller = AnimeListViewController() // État de l'objet pour le contrôleur
    @State private var currentIndex: Int // Index pour le slider
    private var timer: Publishers.Autoconnect<Timer.TimerPublisher> // Déclaration du timer

    init() {
        // Initialiser le timer avec une publication automatique
        timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()
        _currentIndex = State(initialValue: 0) // Initialisation temporaire pour compiler
    }

    var body: some View {
        ZStack {
            // Couleur de fond
            Color.customBackgroundColor
                .edgesIgnoringSafeArea(.all)

       
            VStack {
                HStack {
                    Image("wblogo") 
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200) // Ajustez la taille selon vos besoins
                        .padding(.leading, 20)
                        .offset(x: -55, y:-10)
                    Spacer()
                }
                Spacer()
            }

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
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never)) // Style de page pour le TabView
            .padding(.top, -500) // Ajuste la position du slider
            .onReceive(timer) { _ in // Utilisation correcte du timer
                if !controller.animeList.isEmpty {
                    withAnimation(.easeInOut(duration: 0.5)) { // Ajout d'une animation
                        currentIndex = (currentIndex + 1) % controller.animeList.count // Changer l'index automatiquement
                    }
                }
            }

            // Dots du TabView positionnés sur l'image
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    PageControl(numberOfPages: controller.animeList.count, currentPage: $currentIndex)
                        .padding(.top, -120) // Positionnez les dots
                        .frame(width: UIScreen.main.bounds.width * 0.95, height: 1000)
                    Spacer()
                }
            }
        }
        .onAppear {
            controller.fetchAnimeData() // Récupérer les données des animes lors de l'apparition de la vue
            if !controller.animeList.isEmpty {
                currentIndex = controller.animeList.count / 2 // Commence au milieu de la liste
            }
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

                    // Filtre sombre sur l'image
                    Rectangle()
                        .foregroundColor(Color.black.opacity(0.5)) // Filtre noir avec opacité
                        .cornerRadius(15) // Coin arrondi
                        .frame(width: UIScreen.main.bounds.width * 0.95, height: 200)

                    // Titre de l'anime avec dégradé et ombre
                    // Titre de l'anime avec dégradé et ombre
                    Text(anime.title.romaji)
                        .font(.system(size: 24, weight: .bold, design: .default))
                        .padding(.vertical, 80)
                        .padding(.horizontal, 10)
                        .padding(.top, 100)
                        .frame(maxWidth: .infinity, alignment: .topLeading)
                        .foregroundColor(.white) // Ajoutez cette ligne pour forcer le texte à être blanc
                        .shadow(color: Color.black.opacity(1), radius: 10, x: 10, y: 10)

                }
                .padding()
                .background(Color.clear) // Ajouter un fond transparent autour du ZStack
                .cornerRadius(15)
                .padding()
            } else {
                // Afficher un message si aucun anime n'est disponible
                Text("Aucun anime disponible.")
                    .foregroundColor(.white)
                    .font(.title)
            }
        }
        .padding(.top, 0) // Aucune contrainte de hauteur
    }
}

// Contrôle personnalisé pour les dots
struct PageControl: View {
    var numberOfPages: Int
    @Binding var currentPage: Int

    var body: some View {
        HStack(spacing: 8) { // Espacement entre les dots
            ForEach(0..<numberOfPages, id: \.self) { index in
                Circle()
                    .fill(index == currentPage ? Color.blue : Color.white.opacity(0.5)) // Couleur selon l'état
                    .frame(width: index == currentPage ? 12 : 8, height: index == currentPage ? 12 : 8) // Taille des dots
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
