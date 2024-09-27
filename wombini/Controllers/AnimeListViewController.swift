import SwiftUI
import Combine

class AnimeListViewController: ObservableObject {
    @Published var animeList: [AnimeModel] = []
    private var cancellables = Set<AnyCancellable>()

    func fetchAnimeData() {
        let animeIds = [16498, 21, 20, 30276] // Liste des IDs d'anime

        let group = DispatchGroup()

        for id in animeIds {
            group.enter() // Entrer dans le groupe pour chaque anime
            AnimeAPIService.shared.fetchAnimeData(animeId: id) { [weak self] anime in
                if let anime = anime {
                    self?.animeList.append(anime) // Ajouter l'anime à la liste
                }
                group.leave() // Quitter le groupe
            }
        }

        group.notify(queue: .main) {
            // Actions à réaliser après que tous les appels aient été effectués, si nécessaire
            print("Tous les animes ont été récupérés.")
        }
    }
}
