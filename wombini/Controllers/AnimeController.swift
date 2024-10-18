import Foundation
import Combine

class AnimeController: ObservableObject {
    @Published var animeList: [Anime] = []
    private var cancellables = Set<AnyCancellable>()

    func fetchAnimeData() {
        guard let url = URL(string: "https://api.jikan.moe/v4/top/anime?limit=3") else { return }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: AnimeListResponse.self, decoder: JSONDecoder())
            .map { $0.animes }
            .replaceError(with: [])
            .receive(on: DispatchQueue.main)
            .assign(to: &$animeList)
    }

    func fetchAllAnimeData() {
        guard let url = URL(string: "https://api.jikan.moe/v4/top/anime") else { return }

        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: AnimeListResponse.self, decoder: JSONDecoder())
            .map { $0.animes }
            .replaceError(with: [])
            .receive(on: DispatchQueue.main)
            .assign(to: &$animeList)
    }
    
    
    func fetchCurrentSeason() {
           guard let url = URL(string: "https://api.jikan.moe/v4/seasons/now") else { return }

           URLSession.shared.dataTaskPublisher(for: url)
               .map { $0.data }
               .decode(type: AnimeListResponse.self, decoder: JSONDecoder())
               .map { $0.animes }
               .replaceError(with: [])
               .receive(on: DispatchQueue.main)
               .assign(to: &$animeList)
       }
    
    
    
    func fetchPopularAnimeBySeason(year: Int, season: String) {
        let urlString = "https://api.jikan.moe/v4/seasons/\(year)/\(season)"
        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: AnimeListResponse.self, decoder: JSONDecoder())
            .map { $0.animes }
            .replaceError(with: [])
            .receive(on: DispatchQueue.main)
            .assign(to: &$animeList)
    }
    

    func fetchAnimeRecommendations() {
           guard let url = URL(string: "https://api.jikan.moe/v4/recommendations/anime") else { return }

           URLSession.shared.dataTaskPublisher(for: url)
               .map { $0.data }
               .decode(type: AnimeListResponse.self, decoder: JSONDecoder())
               .map { $0.animes }
               .replaceError(with: [])
               .receive(on: DispatchQueue.main)
               .assign(to: &$animeList)
       }
    
    func fetchTopRatedAnimeData() {
           guard let url = URL(string: "https://api.jikan.moe/v4/top/anime") else { return }

           URLSession.shared.dataTaskPublisher(for: url)
               .map { $0.data }
               .decode(type: AnimeListResponse.self, decoder: JSONDecoder())
               .map { $0.animes }
               .replaceError(with: [])
               .receive(on: DispatchQueue.main)
               .assign(to: &$animeList)
       }
    
    
}
