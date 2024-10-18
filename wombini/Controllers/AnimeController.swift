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
    
    func fetchNewestAnimeData() {
        guard let url = URL(string: "https://api.jikan.moe/v4/seasons/now") else { return }
        
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
            .handleEvents(receiveOutput: { animes in
                print("Fetched anime recommendations: \(animes)")
            })
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
    
    
    func getAnimeMoreInfo(animeId: Int, completion: @escaping (Anime?) -> Void) {
            let urlString = "https://api.jikan.moe/v4/anime/\(animeId)"
            guard let url = URL(string: urlString) else {
                completion(nil)
                return
            }

            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else {
                    completion(nil)
                    return
                }

                do {
                    let animeDetails = try JSONDecoder().decode(Anime.self, from: data)
                    completion(animeDetails)
                } catch {
                    completion(nil)
                }
            }

            task.resume()
        }

    
    func fetchAnimeEpisodes(animeId: Int, completion: @escaping ([Episode]?) -> Void) {
        let urlString = "https://api.jikan.moe/v4/anime/\(animeId)/episodes"
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }

            do {
                let episodeResponse = try JSONDecoder().decode(EpisodeResponse.self, from: data)
                completion(episodeResponse.data)
            } catch {
                completion(nil)
            }
        }.resume()
    }

    
    func getAnimeStatistics(id: String, completion:  @escaping (Welcome?) -> Void) {
        let url = "https://api.jikan.moe/v4/anime/\(id)/statistics"

        
        guard let url = URL(string: url) else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            
            print(data?.debugDescription)
                guard let data = data, error == nil else {
                completion(nil)
                return
            }

            do {
                let statisticsResponse = try JSONDecoder().decode(Welcome.self, from: data)
                completion(statisticsResponse)
            } catch {
                completion(nil)
            }
        }.resume()
        
        
//        let task = URLSession.shared.dataTask(with: url) { data, response, error in
//            if let error = error {
//                completion(.failure(error))
//                return
//            }
//
//            guard let data = data else {
//                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
//                return
//            }
//
//            do {
//                let statisticsResponse = try JSONDecoder().decode(AnimeStatisticsResponse.self, from: data)
//                completion(.success(statisticsResponse))
//            } catch {
//                completion(.failure(error))
//            }
//        }
//
//        task.resume()
    }

    
    
    
    
}
