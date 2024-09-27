//
//  AnimeAPIService.swift
//  wombini
//
//  Created by Jeremie Gavin on 9/27/24.
//

import Foundation

class AnimeAPIService {
    private let baseURL = "https://api.myanimelist.net/v2"
    private let clientID = "VOTRE_CLIENT_ID"
    
    func fetchAnimeList(completion: @escaping (Result<[Anime], Error>) -> Void) {
        let urlString = "\(baseURL)/anime?limit=10"
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }
        
        var request = URLRequest(url: url)
        request.addValue(clientID, forHTTPHeaderField: "X-MAL-CLIENT-ID")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No data received", code: 0, userInfo: nil)))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let animeResponse = try decoder.decode(AnimeResponse.self, from: data)
                completion(.success(animeResponse.data))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}

struct AnimeResponse: Codable {
    let data: [AnimeData]
}

struct AnimeData: Codable {
    let node: Anime
}
