import Foundation

struct AnimeListResponse: Codable {
    struct AnimeData: Codable {
        let mal_id: Int
        let title: String
        let images: Anime.AnimeImages

        var id: Int {
            mal_id
        }
    }

    let data: [AnimeData]

    var animes: [Anime] {
        data.map { Anime(id: $0.mal_id, title: $0.title, images: $0.images) }
    }
}
