struct AnimeListResponse: Codable {
    struct AnimeData: Codable {
        let mal_id: Int
        let title: String
        let images: Anime.AnimeImages
        let score: Double? // Popularity score
        let aired: AiredDates // For release dates
        let seasonYear: Int? // Added for season year

        struct AiredDates: Codable {
            let from: String?
            let to: String?
        }

        var id: Int {
            mal_id
        }

        var releaseDate: String? {
            if let airedFrom = aired.from {
                let year = airedFrom.prefix(4)
                return String(year)
            }
            return nil
        }
    }

    
    let data: [AnimeData]

    var animes: [Anime] {
        data.map {
            Anime(
                id: $0.mal_id,
                title: $0.title,
                images: $0.images,
                releaseDate: $0.releaseDate ?? "N/A",
                score: $0.score,
                seasonYear: $0.seasonYear != nil ? String($0.seasonYear!) : nil
            )
        }
    }
}
