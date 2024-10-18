struct Anime: Codable, Identifiable {
    let id: Int
    let title: String
    let images: AnimeImages
    let releaseDate: String
    let score: Double?

    struct AnimeImages: Codable {
        let jpg: ImageURL
    }

    struct ImageURL: Codable {
        let image_url: String
    }
}
