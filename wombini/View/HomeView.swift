import SwiftUI

struct HomeView: View {
    @StateObject private var controller = AnimeListViewController()
    @State private var showAnimeDetails = false // Variable d'état pour contrôler l'affichage

    var body: some View {
        ZStack(alignment: .topLeading) {
            Color.black
                .edgesIgnoringSafeArea(.all)

            VStack(alignment: .leading) {
                // Afficher l'image et les informations sur Attack on Titan uniquement si showAnimeDetails est true
                if showAnimeDetails, let anime = controller.anime {
                    // Afficher l'image de couverture
                    if let url = URL(string: anime.coverImage.large) {
                        AsyncImage(url: url) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 150, height: 200)
                                .padding(.top, 10) // Ajoute un peu de padding en haut
                        } placeholder: {
                            ProgressView() // Afficher un loader pendant le chargement de l'image
                        }
                    }

                    // Afficher le titre
                    Text(anime.title.romaji)
                        .font(.largeTitle)
                        .foregroundColor(.white)
                        .padding(.top, 10)

                    // Afficher la description
                    Text(anime.description)
                        .font(.body)
                        .foregroundColor(.gray)
                        .padding(.top, 10)
                        .lineLimit(5) // Limiter le nombre de lignes affichées
                }

                Spacer()
                    .frame(height: 20) // Réduire l'espace ici si nécessaire

                // Bouton pour récupérer les données
                Button(action: {
                    controller.fetchAnimeData()
                    showAnimeDetails = true // Afficher les détails après le clic sur le bouton
                }) {
                    Text("Fetch Attack on Titan Data")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.bottom, 20) // Ajoute un peu de padding en bas
            }
            .padding(.leading, 10) // Ajoute un peu de padding à gauche
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
