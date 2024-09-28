import SwiftUI
import Combine

class AnimeListViewController: ObservableObject {
    @Published var animeList: [AnimeModel] = []
    private var cancellables = Set<AnyCancellable>()

    func fetchAnimeData() {
        let animeIds = [16498, 21, 20, 30276] // Liste des IDs d'anime
        let group = DispatchGroup()

        for id in animeIds {
            group.enter()
            AnimeAPIService.shared.fetchAnimeData(animeId: id) { [weak self] anime in
                if let anime = anime {
                    self?.animeList.append(anime)
                    print("Anime récupéré: \(anime.title.romaji)") // Ajout d'une impression ici
                }
                group.leave()
            }
        }

        group.notify(queue: .main) {
            print("Tous les animes ont été récupérés. Nombre total: \(self.animeList.count)")
        }
    }

}
