struct AnimeListResponse: Codable {
    struct AnimeData: Codable {
        let mal_id: Int
        let title: String
        let images: Anime.AnimeImages
        let score: Double?
        let aired: AiredDates

        struct AiredDates: Codable {
            let from: String?
        }

        var id: Int {
            mal_id
        }

        var releaseDate: String {
            aired.from ?? "N/A"
        }
    }
    
    let data: [AnimeData]

    var animes: [Anime] {
        data.map {
            Anime(
                id: $0.mal_id,
                title: $0.title,
                images: $0.images,
                releaseDate: $0.releaseDate,
                score: $0.score
            )
        }
    }
}
