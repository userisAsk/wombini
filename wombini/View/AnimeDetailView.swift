import SwiftUI

struct AnimeDetailView: View {
    @StateObject var animeController = AnimeController()
    @State var episodes: [Episode] = []
    @State var statistics: Welcome?
    var anime: Anime
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                AsyncImage(url: URL(string: anime.images.jpg.image_url)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: .infinity)
                        .cornerRadius(10)
                } placeholder: {
                    ProgressView()
                }
                
                Text(anime.title)
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .padding(.top)
                
                Text("Année de sortie : \(anime.releaseDate)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                if let synopsis = anime.synopsis {
                    Text("Synopsis :")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.top)
                    Text(synopsis)
                        .foregroundColor(.white)
                        .padding(.top)
                }
                
                // Affichage des épisodes
                if !episodes.isEmpty {
                    Text("Épisodes :")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.top)
                    ForEach(episodes) { episode in
                        VStack(alignment: .leading) {
                            Text(episode.title)
                                .font(.subheadline)
                                .foregroundColor(.white)
                            Text("Date de diffusion : \(episode.aired ?? "N/A")")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        .padding(.vertical, 5)
                    }
                } else {
                    ProgressView("Chargement des épisodes...")
                        .foregroundColor(.white)
                }
                
                // Affichage du nombre total d'épisodes
                Text("Nombre total d'épisodes : \(episodes.count)")
                    .foregroundColor(.white)
                    .padding(.top)

                // Affichage des statistiques
                if let statistics = statistics {
                    Text("Statistiques :")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.top)

                    VStack(alignment: .leading) {
                        // Calcul et affichage de la note moyenne
                        let totalVotes = statistics.data.scores.map { $0.votes }.reduce(0, +)
                        let weightedScores = statistics.data.scores.reduce(0) { $0 + ($1.score * $1.votes) }
                        
                        let averageScore = totalVotes > 0 ? Double(weightedScores) / Double(totalVotes) : 0.0
                        
                        Text("Note moyenne : \(String(format: "%.1f", averageScore))")
                            .foregroundColor(.white)

                        // Affichage du nombre total de votes
                        Text("Total de votes : \(totalVotes)")
                            .foregroundColor(.white)
                    }
                } else {
                    ProgressView("Chargement des statistiques...")
                        .foregroundColor(.white)
                }
                
                Spacer()
            }
            .padding()
            .background(Color.customBackgroundColor)
            .navigationTitle(anime.title)
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear {
            animeController.fetchAnimeEpisodes(animeId: anime.id) { fetchedEpisodes in
                if let fetchedEpisodes = fetchedEpisodes {
                    episodes = fetchedEpisodes
                }
            }
            
            animeController.getAnimeStatistics(id: "\(anime.id)") { animeStatisticsResponse in
                if let stats = animeStatisticsResponse {
                    statistics = stats
                }
            }
        }
    }
}
