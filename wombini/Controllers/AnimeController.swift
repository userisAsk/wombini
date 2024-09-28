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
        guard let url = URL(string: "https://api.jikan.moe/v4/anime") else { return }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: AnimeListResponse.self, decoder: JSONDecoder())
            .map { $0.animes }
            .replaceError(with: [])
            .receive(on: DispatchQueue.main)
            .assign(to: &$animeList)
    }
    
    
    
}
