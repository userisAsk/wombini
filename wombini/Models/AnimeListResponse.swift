struct AnimeListResponse: Codable {
    
    struct AnimeData: Codable {
        let mal_id: Int
        let title: String
        let images: Anime.AnimeImages
        let score: Double? // Popularity score
        let aired: AiredDates // For release dates
        let seasonYear: Int? // Added for season year
        let synopsis: String?

        
        

        
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
                seasonYear: $0.seasonYear != nil ? String($0.seasonYear!) : nil,
                synopsis: $0.synopsis
                
            )
        }
    }
}

struct EpisodeResponse: Codable {
    let data: [Episode]
}

struct Episode: Codable, Identifiable {
    let mal_id: Int
    let title: String
    let aired: String?
    let filler: Bool
    let recap: Bool

    var id: Int {
        mal_id
    }
}


struct AnimeStatisticsResponse: Codable, Identifiable {

        let mal_id: Int
        let title: String?
        let episodes: Int?
        let duration: String?
        let rating: String?

        var id: Int {
            mal_id
        }
    
}



// MARK: - Welcome
struct Welcome: Codable {
    let data: DataClass
}

// MARK: - DataClass
struct DataClass: Codable {
    let watching, completed, onHold, dropped: Int
    let planToWatch, total: Int
    let scores: [Score]

    enum CodingKeys: String, CodingKey {
        case watching, completed
        case onHold = "on_hold"
        case dropped
        case planToWatch = "plan_to_watch"
        case total, scores
    }
}

// MARK: - Score
struct Score: Codable {
    let score, votes: Int
    let percentage: Double
}
