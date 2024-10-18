struct Anime: Codable, Identifiable {
    let id: Int
    let title: String
    let images: AnimeImages
    let releaseDate: String // Added for release date
    let score: Double? // Added for popularity score
    let seasonYear: String? // Added for season year

    struct AnimeImages: Codable {
        let jpg: ImageURL
    }

    struct ImageURL: Codable {
        let image_url: String
    }
    
    

}
