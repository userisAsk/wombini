import Foundation

class AnimeAPIService {
    static let shared = AnimeAPIService() // Déclaration du singleton
    private init() {} // Prévenir l'initialisation en dehors de la classe

    func fetchAnimeData(completion: @escaping (AnimeModel?) -> Void) {
        let query = """
        {
            Media(id: 16498, type: ANIME) {
                title {
                    romaji
                }
                description
                coverImage {
                    large
                }
            }
        }
        """

        guard let url = URL(string: "https://graphql.anilist.co/") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let jsonBody = ["query": query]
        request.httpBody = try? JSONSerialization.data(withJSONObject: jsonBody)

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                do {
                    let decodedResponse = try JSONDecoder().decode(AnimeResponse.self, from: data)
                    DispatchQueue.main.async {
                        completion(decodedResponse.data?.Media)
                    }
                } catch {
                    print("Erreur lors du parsing JSON: \(error)")
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                }
            } else {
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }.resume()
    }
}
