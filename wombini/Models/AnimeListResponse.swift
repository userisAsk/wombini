struct AnimeListResponse: Codable {
    struct AnimeData: Codable {
        let mal_id: Int
        let title: String
        let images: Anime.AnimeImages
        let aired: AiredDates // Ajoutez cette structure pour la date

        struct AiredDates: Codable {
            let from: String?
            let to: String?
        }

        var id: Int {
            mal_id
        }

        var releaseDate: String? {
            // Extraire l'année de la date
            if let airedFrom = aired.from {
                let year = airedFrom.prefix(4) // Récupérer les 4 premiers caractères
                return String(year)
            }
            return nil
        }
    }

    let data: [AnimeData]

    var animes: [Anime] {
        data.map { Anime(id: $0.mal_id, title: $0.title, images: $0.images, releaseDate: $0.releaseDate ?? "N/A") }
    }
}

